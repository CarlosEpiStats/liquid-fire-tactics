class_name AddValueModifier
extends ValueModifier

var _to_add: float

func _init(sort_order: int, to_add: float) -> void:
	super(sort_order)
	_to_add = to_add


func modify(from_value: float, to_value: float) -> float:
	return to_value + _to_add
