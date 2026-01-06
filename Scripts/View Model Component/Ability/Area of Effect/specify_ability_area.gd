extends AbilityArea

@export var horizontal: int = 6
@export var min_h: int = 1
@export var vertical: int = 2
@export var use_ability_range: bool = false
@export var extend_past_target: bool = false

var target_tile: Tile 
var unit_tile: Tile

# Attacks everything in stratight line between the unit and the target
func get_tiles_in_area(board: BoardCreator, pos: Vector2i):
	var ret_value: Array[Tile] = []
	target_tile = board.get_tile(pos)
	unit_tile = self.get_node("../../../").tile
	
	var number_steps = longest_side(unit_tile.pos, target_tile.pos)
	var max_steps = range_h if use_ability_range else horizontal
	var min_steps = range_min_h if use_ability_range else min_h
	
	for i in range(min_steps, max_steps + 1):
		if not extend_past_target and i > number_steps + 1:
			break
		
		var lerp_amount: float = 0 if number_steps == 0 else float(i) / number_steps
		var point: Vector2 = lerp(Vector2(unit_tile.pos), Vector2(target_tile.pos), lerp_amount)
		var tile: Tile = board.get_tile(point.round())
		if distance(unit_tile.pos, point.round()) > max_steps:
			break
		
		if valid_tile(tile, lerp_amount):
			ret_value.append(tile)
	
	return ret_value


func longest_side(p0: Vector2i, p1: Vector2i):
	var dist_x = p1.x - p0.x
	var dist_y = p1.y - p0.y
	return max(abs(dist_x), abs(dist_y))


func distance(p0: Vector2i, p1: Vector2i):
	var dist_x = p1.x - p0.x
	var dist_y = p1.y - p0.y
	return abs(dist_x) + abs(dist_y)


func valid_tile(t: Tile, lerp_distance: float):
	var height: int = round(lerp(unit_tile.height, target_tile.height, lerp_distance))
	return t != null and abs(t.height - height) <= vertical
