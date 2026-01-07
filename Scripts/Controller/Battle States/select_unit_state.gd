extends BattleState

@export var command_selection_state: State

func enter():
	super()
	change_current_unit()


func change_current_unit():
	turn_controller.round_resumed.emit()
	select_tile(turn.actor.tile.pos)
	_owner.state_machine.change_state(command_selection_state)
