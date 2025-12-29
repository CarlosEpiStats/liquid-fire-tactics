class_name Repeater

# How often the button will register after being held
# 250 miliseconds = 4 times every second
const _RATE: int = 250

# Keep track of the time that has elapsed
var _next: int

# Store which axis is being used
var _axis_pos: String
var _axis_neg: String

func _init(negative_axis: String, positive_axis: String):
	_axis_neg = negative_axis
	_axis_pos = positive_axis

# Call each frame to check if we should call any new events
func update():
	var ret_value: int = 0
	var value: int = roundi(Input.get_axis(_axis_neg, _axis_pos))
	
	if value != 0:
		if Time.get_ticks_msec() > _next:
			ret_value = value
			_next = Time.get_ticks_msec() + _RATE
	else:
		_next = 0
	
	return ret_value
