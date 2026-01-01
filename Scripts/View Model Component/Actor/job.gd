class_name Job
extends Node

const STAT_ORDER: Array[StatTypes.Stat] = [
	StatTypes.Stat.MHP, 
	StatTypes.Stat.MMP, 
	StatTypes.Stat.ATK,
	StatTypes.Stat.DEF,
	StatTypes.Stat.MAT,
	StatTypes.Stat.MDF,
	StatTypes.Stat.SPD,
	]

@export var base_stats: Array[int]
@export var grow_stats: Array[float]
var stats: Stats

func _init():
	base_stats.resize(STAT_ORDER.size())
	base_stats.fill(0)
	grow_stats.resize(STAT_ORDER.size())
	grow_stats.fill(0)

	
func employ():
	for child in self.get_parent().get_children():
		if child is Stats:
			stats = child
	stats.did_change_notification(StatTypes.Stat.LVL).connect(on_lvl_change_notification)	

	var features: Array[Node] = self.get_children()
	
	var filtered_array = features.filter(func(node): return node is Feature)
	for node in filtered_array:
		node.activate(self.get_parent())
	
func unemploy():
	var features: Array[Node] = self.get_parent().get_children()
	
	var filtered_array = features.filter(func(node): return node is Feature)
	for node in filtered_array:
		node.deactivate()

	stats.did_change_notification(StatTypes.Stat.LVL).disconnect(on_lvl_change_notification)
	stats = null

func load_default_stats():
	for i in STAT_ORDER.size():
		stats.set_stat(STAT_ORDER[i], base_stats[i], false)
		
	stats.set_stat(StatTypes.Stat.HP, stats.get_stat(StatTypes.Stat.MHP), false)
	stats.set_stat(StatTypes.Stat.MP, stats.get_stat(StatTypes.Stat.MMP), false)

func on_lvl_change_notification(sender: Stats, old_value: int):
	var new_level = stats.get_stat(StatTypes.Stat.LVL)
	for i in range(old_value, new_level, 1):
		level_up()

func level_up():
	for i in STAT_ORDER.size():
		var type: StatTypes.Stat = STAT_ORDER[i]
		var whole: int = floori(grow_stats[i])
		var fraction: float = grow_stats[i] - whole
		var value: int = stats.get_stat(type)
		value += whole
		
		if randf() > (1.0 - fraction):
			value += 1
			
		stats.set_stat(type, value, false)
		
	stats.set_stat(StatTypes.Stat.HP, stats.get_stat(StatTypes.Stat.MHP), false)
	stats.set_stat(StatTypes.Stat.MP, stats.get_stat(StatTypes.Stat.MMP), false)
