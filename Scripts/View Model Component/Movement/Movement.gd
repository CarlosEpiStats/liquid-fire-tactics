extends Node
class_name Movement

var range: int
var jumpHeight: int
var unit: Unit
var jumper: Node3D

func _init():
	unit = get_node("../")
	jumper = get_node("../Jumper")

func GetTilesInRange(board: BoardCreator):
	var retValue = board.Search(unit.tile, ExpandSearch)
	Filter(retValue)
	return retValue

# Returns true if it's a valid location to move to
func ExpandSearch(from:Tile, to:Tile):
	return from.distance + 1 <= range

# Filter out tiles that can't be stopped on
func Filter(tiles:Array):
	for i in range(tiles.size()-1, -1, -1):
		if tiles[i].content != null:
			tiles.remove_at(i)

func Traverse(tile:Tile):
	pass

func Turn(dir:Directions.Dirs):
	if unit.dir == Directions.Dirs.SOUTH && dir == Directions.Dirs.WEST:
		unit.rotation_degrees.y = 360
	elif unit.dir == Directions.Dirs.WEST && dir == Directions.Dirs.SOUTH:
		unit.rotation_degrees.y = -90
	
	# A tween is an anmiator that we set a start and end point, and then we
	# let the computer fill in everything in-between
	var tween = create_tween()
	unit.dir = dir
	tween.tween_property(
		unit, # object to animate
		"rotation_degrees", # property to animate
		Directions.ToEuler(dir), # value we are going to
		.25, # duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT) # special transitions
	await tween.finished
