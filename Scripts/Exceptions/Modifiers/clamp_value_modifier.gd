class_name ClampValueModifier
extends ValueModifier

var _min: float
var _max: float

func _init(sort_order: int, min: float, max: float) -> void:
	super(sort_order)
	_min = min
	_max = max


func modify(from_value: float, to_value: float) -> float:
	return clamp(to_value, _min, _max)
