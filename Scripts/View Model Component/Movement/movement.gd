class_name Movement
extends Node

var range: int
var jump_height: int
var unit: Unit
var jumper: Node3D

func _init():
	unit = get_node("../")
	jumper = get_node("../Jumper")

func get_tiles_in_range(board: BoardCreator):
	var ret_value = board.search(unit.tile, expand_search)
	filter(ret_value)
	return ret_value

# Returns true if it's a valid location to move to
func expand_search(from: Tile, to: Tile):
	return from.distance + 1 <= range

# filter out tiles that can't be stopped on
func filter(tiles: Array):
	for i in range(tiles.size() - 1, -1, -1):
		if tiles[i].content != null:
			tiles.remove_at(i)

func traverse(tile:Tile):
	pass

func turn(dir: Directions.Dirs):
	if unit.dir == Directions.Dirs.SOUTH and dir == Directions.Dirs.WEST:
		unit.rotation_degrees.y = 360
	elif unit.dir == Directions.Dirs.WEST and dir == Directions.Dirs.SOUTH:
		unit.rotation_degrees.y = -90
	
	# A tween is an anmiator that we set a start and end point, and then we
	# let the computer fill in everything in-between
	var tween = create_tween()
	unit.dir = dir
	tween.tween_property(
		unit, # object to animate
		"rotation_degrees", # property to animate
		Directions.to_euler(dir), # value we are going to
		.25, # duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT) # special transitions
	await tween.finished
