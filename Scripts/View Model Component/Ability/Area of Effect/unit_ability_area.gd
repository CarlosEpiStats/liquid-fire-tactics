extends AbilityArea

# Returns the single tile as long as the tile is valid
func get_tiles_in_area(board: BoardCreator, pos: Vector2i):
	var ret_value: Array[Tile] = []
	var tile: Tile = board.get_tile(pos)
	if tile != null:
		ret_value.append(tile)
	
	return ret_value
