extends BattleState

@export var command_selection_state: State
var index: int = -1

func enter():
	super()
	change_current_unit()


func change_current_unit():
	index = (index + 1) % units.size()
	turn.change(units[index])
	_owner.state_machine.change_state(command_selection_state)
