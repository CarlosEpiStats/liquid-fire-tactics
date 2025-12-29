class_name ButtonRepeater

const _RATE: int = 50
var _next: int
var _button: String

func _init(limit_button: String):
	_button = limit_button

func update():
	# For mouse wheel (act as a button, can't be hold)
	if Input.is_action_just_pressed(_button):
		_next = Time.get_ticks_msec() + _RATE
		return true
	
	# For a button other than the mouse wheel
	if Input.is_action_pressed(_button): 
		if Time.get_ticks_msec() > _next:
			_next = Time.get_ticks_msec() + _RATE
			return true

	return false
