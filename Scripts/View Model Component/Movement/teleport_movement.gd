class_name TeleportMovement
extends Movement

func get_tiles_in_range(board: BoardCreator):
	var ret_value = board.range_search(unit.tile, expand_search, range)
	filter(ret_value)
	return ret_value

func expand_search(from: Tile, to: Tile):
	return abs(from.pos.x - to.pos.x) + abs(from.pos.y - to.pos.y) <= range

func traverse(tile: Tile):
	unit.place(tile)

	var spin_tween = create_tween()
	spin_tween.tween_property(
		jumper,
		"rotation",
		Vector3(0,360, 0),
		.5
	).set_trans(Tween.TRANS_LINEAR)

	var scale_tween = create_tween()
	scale_tween.tween_property(
		jumper,
		"scale",
		Vector3(0,0,0),
		0.5
	)
	await scale_tween.finished

	unit.position = tile.center()

	spin_tween = create_tween()
	spin_tween.tween_property(
		jumper,
		"rotation",
		Vector3(0,0, 0),
		.5
	).set_trans(Tween.TRANS_LINEAR)

	scale_tween = create_tween()
	scale_tween.tween_property(
		jumper,
		"scale",
		Vector3(1,1,1),
		0.5
	)  
	await scale_tween.finished
