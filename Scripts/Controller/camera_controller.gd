class_name CameraController
extends Node

@export var _follow_speed: float = 3.0
var _follow: Node3D
var _min_zoom = 5
var _max_zoom = 20
var _zoom = 10
var _min_pitch = -90
var _max_pitch = 0


func zoom(scroll: int):
	_zoom = clamp(_zoom + scroll, _min_zoom, _max_zoom)
	
	if $Heading/Pitch/Camera3D.projection == Camera3D.PROJECTION_ORTHOGONAL:
		$Heading/Pitch/Camera3D.position.z = 100
		$Heading/Pitch/Camera3D.size = _zoom
	else:
		$Heading/Pitch/Camera3D.position.z = _zoom


func orbit(direction: Vector2):
	if direction.x != 0:
		var heading_speed = 2
		var heading_angle = $Heading.rotation.y
		heading_angle += direction.x * heading_speed * get_process_delta_time()
		$Heading.rotation.y = heading_angle
		while $Heading.rotation.y > deg_to_rad(360):
			$Heading.rotation.y -= deg_to_rad(720)
		while $Heading.rotation.y < deg_to_rad(-360):
			$Heading.rotation.y += deg_to_rad(720)
		
	if direction.y !=0:
		var orbitSpeed = 2
		var v_angle = direction.y
		var orbit_angle = $Heading/Pitch.rotation.x
		orbit_angle += direction.y * orbitSpeed * get_process_delta_time()
		orbit_angle = clamp(orbit_angle, deg_to_rad(_min_pitch), deg_to_rad(_max_pitch) )
		$Heading/Pitch.rotation.x = orbit_angle


func adjusted_movement(original_point: Vector2i):
	var angle = rad_to_deg($Heading.rotation.y)

	if (angle >= -45 and angle < 45) or (angle < -315 or angle >= 315):
		return original_point
		
	elif (angle >= 45 and angle < 135) or (angle >= -315 and angle < -225):
		return Vector2i(original_point.y, original_point.x * -1)
		
	elif (angle >= 135 and angle < 225) or (angle >= -225 and angle < -135):
		return Vector2i(original_point.x * -1, original_point.y * -1)

	elif (angle >= 225 and angle < 315) or (angle >= -135 and angle < -45):
		return Vector2i(original_point.y * -1, original_point.x)

	else:
		print("Camera angle is wrong: " + str(angle))
		return original_point


func _process(delta):
	if _follow:
		self.position = self.position.lerp(_follow.position, _follow_speed * delta)


func set_follow(follow: Node3D):
	if follow:
		_follow = follow
