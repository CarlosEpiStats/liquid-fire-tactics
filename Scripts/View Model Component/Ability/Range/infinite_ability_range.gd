extends AbilityRange

enum Calc {
	ALL,
	HEIGHT,
}

@export var option: Calc = Calc.ALL

func get_tiles_in_range(board: BoardCreator):
	if option == Calc.ALL:
		return board.tiles.values()
	
	else:
		var ret_value: Array[Tile] = []
		for tile in board.tiles.values():
			if valid_tile(tile):
				ret_value.append(tile)
		
		return ret_value


func valid_tile(t: Tile):
	match option:
		Calc.HEIGHT:
			if t.content != null:
				if t.height % 2 == 0:
					return true
		
		_:
			return false
	return false
