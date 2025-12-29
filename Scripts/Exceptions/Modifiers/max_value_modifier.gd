class_name MaxValueModifier
extends ValueModifier

var _max: float

func _init(sort_order: int, max: float) -> void:
	super(sort_order)
	_max = max


func modify(from_value: float, to_value: float) -> float:
	return max(to_value, _max)
