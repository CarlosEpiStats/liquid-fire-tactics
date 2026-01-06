extends AbilityRange

@export var width = 1
var _dirs = [Vector2i(1, 1), Vector2i(-1, -1), Vector2i(1, -1), Vector2i(-1, 1)]

func valid_tile(t: Tile):
	return t != null and abs(t.height - unit.tile.height) <= vertical


func get_tiles_in_range(board: BoardCreator):
	var ret_value: Array[Tile] = []
	var pos: Vector2i = unit.tile.pos
	
	for i in range(min_h, horizontal + 1):
		for dir in _dirs:
			var side_a := Vector2i(-dir.x, dir.y)
			var side_b := Vector2i(dir.x, -dir.y)
			var vector_a: Vector2i
			var vector_b: Vector2i
			
			for w in range(1, width + 1):
				if w == 1:
					var tile_vector: Vector2i = pos + dir * i
					var tile: Tile = board.get_tile(tile_vector)
					if valid_tile(tile):
						ret_value.append(tile)
					
					vector_a = dir * i
					vector_b = dir * i
				
				else:
					vector_a = Vector2i(vector_a.x + side_a.x * w % 2, vector_a.y + side_a.y * (1 - w % 2))
					vector_b = Vector2i(vector_b.x + side_b.x * (1 - w % 2), vector_b.y + side_b.y * w % 2)
					
					if abs(vector_a.x) + abs(vector_a.y) <= horizontal * 2:
						var tile: Tile = board.get_tile(vector_a + pos)
						if valid_tile(tile):
							ret_value.append(tile)
					
					if abs(vector_b.x) + abs(vector_b.y) <= horizontal * 2:
						var tile: Tile = board.get_tile(vector_b + pos)
						if valid_tile(tile):
							ret_value.append(tile)
	
	return ret_value
