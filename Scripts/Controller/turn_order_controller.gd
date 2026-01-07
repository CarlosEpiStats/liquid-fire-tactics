class_name TurnOrderController
extends Node

const TURN_ACTIVATION: int = 1000 # minimum value the CTR needs to hit
const TURN_COST: int = 500 # minimum CTR spent once a turn is finished
const MOVE_COST: int = 300 # additonal CTR down if a unit moves
const ACTION_COST: int = 200 # additional CTR down if a unit takes an action

signal round_began()
signal turn_checked(exc: BaseException)
signal turn_completed(unit: Unit)
signal round_ended()
signal round_resumed()

func _ready() -> void:
	turn_round()


# Loop through the characters and modify their CTR
# Infinite loop: as long as there are units on the field
# A round is a single loop through all the characters
func turn_round():
	var bc: BattleController = get_parent()
	await round_resumed
	while true:
		round_began.emit()
		var units: Array[Unit] = bc.units.duplicate()
		for unit in units:
			var s: Stats = unit.get_node("Stats")
			s.set_stat(StatTypes.Stat.CTR, s.get_stat(StatTypes.Stat.CTR) + s.get_stat(StatTypes.Stat.SPD))
		
		units.sort_custom(func(a, b): return get_counter(a) > get_counter(b))
		
		for unit in units:
			if can_take_turn(unit):
				bc.turn.change(unit)
				await round_resumed
				var cost: int = TURN_COST
				if bc.turn.has_unit_moved:
					cost += MOVE_COST
				
				if bc.turn.has_unit_acted:
					cost += ACTION_COST
				
				var s: Stats = unit.get_node("Stats")
				s.set_stat(StatTypes.Stat.CTR, s.get_stat(StatTypes.Stat.CTR) - cost, false)
				turn_completed.emit()
		
		round_ended.emit()


func can_take_turn(target: Unit):
	var exc := BaseException.new(get_counter(target) >= TURN_ACTIVATION)
	turn_checked.emit(exc)
	return exc.toggle


func get_counter(target: Unit):
	var s: Stats = target.get_node("Stats")
	return s.get_stat(StatTypes.Stat.CTR)
