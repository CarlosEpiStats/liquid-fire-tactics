extends AbilityArea

# Grabs all the tiles from the range function (useful for directional range type
# such as cone)
func get_tiles_in_area(board: BoardCreator, pos: Vector2i):
	return _get_range().get_tiles_in_range(board)
