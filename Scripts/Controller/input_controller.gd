class_name InputController
extends Node

signal move_event(point: Vector2i)
signal fire_event(button: int)
signal quit_event()
signal camera_rotate_event(point: Vector2)
signal camera_zoom_event(scroll: int)

var _hor := Repeater.new("move_left", "move_right")
var _ver := Repeater.new("move_up", "move_down")
var buttons = ["fire_1", "fire_2", "fire_3", "fire_4"]
var _cam_zoom_up := ButtonRepeater.new("zoom_up")
var _cam_zoom_down := ButtonRepeater.new("zoom_down")
var _last_mouse: Vector2

func _process(delta: float) -> void:
	var x = _hor.update()
	var y = _ver.update()
	
	if x != 0 or y != 0:
		move_event.emit(Vector2i(x, y))
	
	# Check buttons pressed and send the button number
	for i in range(buttons.size()):
		if Input.is_action_just_pressed(buttons[i]):
			fire_event.emit(i)
	
	if Input.is_action_just_pressed("quit"):
		quit_event.emit()
	
	# Camera Zoom
	if _cam_zoom_up.update():
		camera_zoom_event.emit(-1)
	
	if _cam_zoom_down.update():
		camera_zoom_event.emit(1)
	
	# Camera rotation
	var cam_x = Input.get_axis("camera_right","camera_left")
	var cam_y = Input.get_axis("camera_down", "camera_up")

	if cam_x != 0 or cam_y != 0:
		camera_rotate_event.emit(Vector2(cam_x, cam_y))
	
	if Input.is_action_just_pressed("camera_activate"):
		_last_mouse = get_viewport().get_mouse_position()

	if Input.is_action_pressed("camera_activate"):
		var current_mouse: Vector2 = get_viewport().get_mouse_position()
		
		if _last_mouse != current_mouse:
			var mouse_vector: Vector2 = _last_mouse - current_mouse
			_last_mouse = current_mouse
			var vector_limit = 10
			var new_vector: Vector2 = mouse_vector / vector_limit
			camera_rotate_event.emit(new_vector)
