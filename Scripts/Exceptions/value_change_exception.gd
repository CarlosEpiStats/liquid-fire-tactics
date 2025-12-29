class_name ValueChangeException
extends BaseException

var _from_value: float
var _to_value: float
var delta: float:
	get:
		return _to_value - _from_value

var modifiers: Array[ValueModifier] = []

func _init(from_value: float, to_value: float) -> void:
	super(true)
	_from_value = from_value
	_to_value = to_value


func add_modifiers(m: ValueModifier):
	modifiers.append(m)


func get_modified_value() -> float:
	if modifiers.size() == 0:
		return _to_value
	
	var value = _to_value
	modifiers.sort_custom(compare)
	for modifier in modifiers:
		value = modifier.modify(_from_value, value)
	
	return value


func compare(a: ValueModifier, b: ValueModifier):
	return a.sort_order < b.sort_order
