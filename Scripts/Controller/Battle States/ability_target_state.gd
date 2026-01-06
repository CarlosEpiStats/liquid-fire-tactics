extends BattleState

@export var command_selection_state: State
@export var category_selection_state: State

var tiles = []
var ar: AbilityRange

# we get the node from turn.ability which would be the node Attack
# and search for children with an ability range attached
func enter():
	super()
	var filtered: Array[Node] = turn.ability.get_children().filter(func(node): return node is AbilityRange)
	ar = filtered[0]
	select_tiles()
	stat_panel_controller.show_primary(turn.actor)
	if ar.direction_oriented:
		refresh_secondary_stat_panel(pos)


func exit():
	super()
	board.deselect_tiles(tiles)
	await stat_panel_controller.hide_primary()
	await stat_panel_controller.hide_secondary()


# if the range is direction based, the unit will change direction,
# if it's not, the cursor should move around the board to select a tile
func on_move(e: Vector2i):
	var rotated_point = _owner.camera_controller.adjusted_movement(e)
	if ar.direction_oriented:
		change_direction(rotated_point)
	
	else:
		select_tile(rotated_point + pos)
		refresh_secondary_stat_panel(pos)


func on_fire(e: int):
	if e == 0:
		turn.has_unit_acted = true
		if turn.has_unit_moved:
			turn.lock_move = true
		
		_owner.state_machine.change_state(command_selection_state)
	
	else:
		_owner.state_machine.change_state(category_selection_state)


func change_direction(p: Vector2i):
	var dir: Directions.Dirs = Directions.to_dir(p)
	if turn.actor.dir != dir:
		board.deselect_tiles(tiles)
		turn.actor.dir = dir
		turn.actor.match_unit()
		select_tiles()


func select_tiles():
	tiles = ar.get_tiles_in_range(board)
	board.select_tiles(tiles)


func zoom(scroll: int):
	_owner.camera_controller.zoom(scroll)


func orbit(direction: Vector2):
	_owner.camera_controller.orbit(direction)
