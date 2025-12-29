extends BattleState

@export var command_selection_state: State

func enter():
	super()
	sequence()

func sequence():	
	var m: Movement = turn.actor.get_node("Movement")
	_owner.camera_controller.set_follow(turn.actor)
	await m.traverse(_owner.current_tile)
	_owner.camera_controller.set_follow(_owner.board.marker)
	turn.has_unit_moved = true
	_owner.state_machine.change_state(command_selection_state)
