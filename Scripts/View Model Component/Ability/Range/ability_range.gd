class_name AbilityRange
extends Node

@export var horizontal: int = 1
@export var min_h: int = 0
@export var vertical: int = 999_999

var unit: Unit:
	get:
		return get_node("../../..")

var direction_oriented: bool:
	get = _get_direction_oriented


func _get_direction_oriented():
	return false


func get_tiles_in_range(board: BoardCreator):
	pass
