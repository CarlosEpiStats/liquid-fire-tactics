extends AbilityRange

func get_tiles_in_range(board: BoardCreator):
	var ret_value = board.range_search(unit.tile, expand_search, horizontal)
	return ret_value


func expand_search(from: Tile, to: Tile):
	var dist = abs(from.pos.x - to.pos.x) + abs(from.pos.y - to.pos.y)
	return dist <= horizontal and dist >= min_h and abs(from.height - to.height) <= vertical
