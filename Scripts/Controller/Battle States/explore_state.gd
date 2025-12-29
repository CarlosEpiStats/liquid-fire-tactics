extends BattleState

@export var command_selection_state: State

func on_move(e: Vector2i):
	var rotated_point = _owner.camera_controller.adjusted_movement(e)
	select_tile(rotated_point + _owner.board.pos)


func on_fire(e: int):
	print("Fire " + str(e))
	if e == 0:
		_owner.state_machine.change_state(command_selection_state)


func zoom(scroll: int):
	_owner.camera_controller.zoom(scroll)


func orbit(direction: Vector2):
	_owner.camera_controller.orbit(direction)
