class_name StatModifierFeature
extends Feature

@export var type: StatTypes.Stat
@export var amount: int
var stats: Stats:
	get: 
		return _target.get_node("Stats")

func on_apply():
	var start_value = stats.get_stat(type)
	stats.set_stat(type, start_value + amount)


func on_remove():
	var start_value = stats.get_stat(type)
	stats.set_stat(type, start_value - amount)
	
