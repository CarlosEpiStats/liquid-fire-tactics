extends BattleState

@export var move_sequence_state: State
@export var command_selection_state: State

var tiles = []

func enter():
	super()
	var mover: Movement = turn.actor.get_node("Movement")
	tiles = mover.get_tiles_in_range(_owner.board)
	_owner.board.select_tiles(tiles)
	refresh_primary_stat_panel(_owner.board.pos)

func exit():
	super()
	_owner.board.deselect_tiles(tiles)
	tiles = null
	await stat_panel_controller.hide_primary()

func on_move(e: Vector2i):
	var rotated_point = _owner.camera_controller.adjusted_movement(e)
	select_tile(rotated_point + _owner.board.pos)
	refresh_primary_stat_panel(_owner.board.pos)

func on_fire(e: int):
	if e == 0:
		if tiles.has(_owner.current_tile):
			_owner.state_machine.change_state(move_sequence_state)
	else:
		_owner.state_machine.change_state(command_selection_state)
	print("Fire: " + str(e))

func zoom(scroll: int):
	_owner.camera_controller.zoom(scroll)
	
func orbit(direction: Vector2):
	_owner.camera_controller.orbit(direction)
