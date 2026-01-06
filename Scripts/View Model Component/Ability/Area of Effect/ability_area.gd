class_name AbilityArea
extends Node

var range_h: int:
	get:
		return _get_range().horizontal

var range_min_h: int:
	get:
		return _get_range().min_h

var range_v: int:
	get:
		return _get_range().vertical

func _get_range():
	var filtered: Array[Node] = self.get_parent().get_children().filter(func(node): return node is AbilityRange)
	var range: AbilityRange = filtered[0]
	return range


func get_tiles_in_area(board: BoardCreator, pos: Vector2i):
	pass
