extends BattleState

@export var end_facing_state: BattleState
@export var command_selection_state: BattleState

func enter():
	super()
	turn.has_unit_acted = true
	if turn.has_unit_moved:
		turn.lock_move = true
	
	await animate()


func animate():
	# TODO play animations, etc
	# TODO apply ability effect, etc
	
	temporary_attack_example()
	if turn.has_unit_moved:
		_owner.state_machine.change_state(end_facing_state)
	
	else:
		_owner.state_machine.change_state(command_selection_state)


func temporary_attack_example():
	for i in range(0, turn.targets.size()):
		var obj = turn.targets[i].content
		var stats: Stats
		if obj != null:
			stats = obj.get_node("Stats")
		
		if stats != null:
			stats.set_stat(StatTypes.Stat.HP, stats.get_stat(StatTypes.Stat.HP) - 15)
			if stats.get_stat(StatTypes.Stat.HP) <= 0:
				print("KO'd {Unit}!".format({"Unit": obj.name}))
