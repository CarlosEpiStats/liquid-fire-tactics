class_name MinValueModifier
extends ValueModifier

var _min: float

func _init(sort_order: int, min: float) -> void:
	super(sort_order)
	_min = min


func modify(from_value: float, to_value: float) -> float:
	return min(to_value, _min)
