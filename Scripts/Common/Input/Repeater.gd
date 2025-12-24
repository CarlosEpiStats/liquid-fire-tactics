class_name Repeater

# How often the button will register after being held
# 250 miliseconds = 4 times every second
const _rate: int = 250

# Keep track of the time that has elapsed
var _next: int

# Store which axis is being used
var _axisPos: String
var _axisNeg: String

func _init(negativeAxis: String, positiveAxis: String):
	_axisNeg = negativeAxis
	_axisPos = positiveAxis

# Call each frame to check if we should call any new events
func Update():
	var retValue: int = 0
	var value: int = roundi(Input.get_axis(_axisNeg, _axisPos))
	
	if value != 0:
		if Time.get_ticks_msec() > _next:
			retValue = value
			_next = Time.get_ticks_msec() + _rate
	else:
		_next = 0
	
	return retValue
