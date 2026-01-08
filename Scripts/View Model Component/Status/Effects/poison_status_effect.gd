class_name PoisonStatusEffect
extends StatusEffect

var unit: Unit
var turn_controller

func _enter_tree():
	turn_controller = get_node("/root/Battle/Battle Controller/TurnOrderController")
	unit = self.get_parent().get_parent()
	if unit:
		turn_controller.turn_began(unit).connect(on_new_turn)


func _exit_tree() -> void:
	turn_controller.turn_began(unit).disconnect(on_new_turn)


func on_new_turn():
	var s: Stats = unit.get_node("Stats")
	var current_hp: int = s.get_stat(StatTypes.Stat.HP)
	var max_hp: int = s.get_stat(StatTypes.Stat.MHP)
	var reduce: int = min(current_hp, floori(max_hp * 0.1))
	s.set_stat(StatTypes.Stat.HP, current_hp - reduce, false)
