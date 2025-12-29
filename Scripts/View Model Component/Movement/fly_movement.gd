class_name FlyMovement
extends Movement

# override using range_search instead of standard Search
func get_tiles_in_range(board: BoardCreator):
	var ret_value = board.range_search(unit.tile, expand_search, range)
	filter(ret_value)
	return ret_value

func expand_search(from: Tile, to: Tile):
	return abs(from.pos.x - to.pos.x) + abs(from.pos.y - to.pos.y) <= range

func traverse(tile: Tile):
	# Store the distance  and direction between the start tile and target tile
	var dist: float = sqrt(pow(tile.pos.x - unit.tile.pos.x, 2) + pow(tile.pos.y - unit.tile.pos.y, 2))
	var dir: Directions.Dirs = Directions.get_direction(unit.tile, tile)
	unit.place(tile)
	
	# Fly high enough not to clip through any ground tiles
	var y: float = Tile.STEP_HEIGHT * 10
	var duration: float = y * 0.25
	
	var tween = create_tween()
	
	tween.tween_property(
		jumper,
		"position",
		Vector3(0, y, 0),
		duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	
	# turn to face the general direction
	await turn(dir)
	
	# Move to the correct position
	tween = create_tween()
	tween.tween_property(
		unit,
		"position",
		tile.center(),
		dist * .5
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

	# Land
	tween.tween_property(
		jumper,
		"position",
		Vector3(0, 0, 0),
		duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
