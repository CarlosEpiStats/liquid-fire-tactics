extends BattleState

@export var select_unit_state: BattleState
@export var command_selection_state: BattleState

var start_dir: Directions.Dirs

func enter():
	super()
	start_dir = turn.actor.dir
	select_tile(turn.actor.tile.pos)


func on_move(e: Vector2i):
	var rotated_point = _owner.camera_controller.adjusted_movement(e)
	turn.actor.dir = Directions.to_dir(rotated_point)
	turn.actor.match_unit()


func on_fire(e: int):
	match e:
		0:
			_owner.state_machine.change_state(select_unit_state)
		
		1:
			turn.actor.dir = start_dir
			turn.actor.match_unit()
			_owner.state_machine.change_state(command_selection_state)


func zoom(scroll: int):
	_owner.camera_controller.zoom(scroll)


func orbit(direction: Vector2):
	_owner.camera_controller.orbit(direction)
