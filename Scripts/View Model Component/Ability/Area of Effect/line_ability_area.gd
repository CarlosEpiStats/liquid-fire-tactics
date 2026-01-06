extends AbilityArea

@export var horizontal: int = 2
@export var vertical: int = 999_999
var tile: Tile 

# Expands the range out the specified distance
func get_tiles_in_area(board: BoardCreator, pos: Vector2i):
	var tile = board.get_tile(pos)
	return board.range_search(tile, expand_search, horizontal)


func expand_search(from: Tile, to: Tile):
	return (from.distance + 1) <= horizontal and abs(to.height - tile.height) <= vertical
	
