extends AbilityRange

func get_tiles_in_range(board: BoardCreator):
	var ret_value: Array[Tile] = []
	ret_value.append(unit.tile)
	return ret_value
