class_name MultDeltaModifier
extends ValueModifier

var _to_multiply: float

func _init(sort_order: int, to_multiply: float) -> void:
	super(sort_order)
	_to_multiply = to_multiply


func modify(from_value: float, to_value: float) -> float:
	var delta: float = to_value - from_value
	return from_value + delta * _to_multiply
