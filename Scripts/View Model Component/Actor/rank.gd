class_name Rank
extends Node

const MIN_LEVEL: int = 1
const MAX_LEVEL: int = 99
const MAX_EXPERIENCE: int = 999_999

var stats: Stats

var lvl: int:
	get:
		return stats.get_stat(StatTypes.Stat.LVL)


var xp: int:
	get:
		return stats.get_stat(StatTypes.Stat.EXP)
	
	set(value):
		stats.set_stat(StatTypes.Stat.EXP, value)


var level_percent: float:
	get:
		return (float)(lvl - MIN_LEVEL) / (float)(MAX_LEVEL - MIN_LEVEL)


func _ready() -> void:
	stats = get_node("../Stats")
	stats.will_change_notification(StatTypes.Stat.EXP).connect(on_exp_will_change)
	stats.did_change_notification(StatTypes.Stat.EXP).connect(on_exp_did_change)


func _exit_tree() -> void:
	stats.will_change_notification(StatTypes.Stat.EXP).disconnect(on_exp_will_change)
	stats.did_change_notification(StatTypes.Stat.EXP).disconnect(on_exp_did_change)


func on_exp_will_change(sender: Stats, vce: ValueChangeException):
	vce.add_modifiers(ClampValueModifier.new(999_999, xp, MAX_EXPERIENCE))


func on_exp_did_change(sender: Stats, old_value: int):
	stats.set_stat(StatTypes.Stat.LVL, level_for_experience(xp), false)


static func experience_for_level(level: int) -> int:
	var level_percent = clamp((float)(level - MIN_LEVEL) / (float)(MAX_LEVEL - MIN_LEVEL), 0, 1)
	return (int)(MAX_EXPERIENCE * ease(level_percent, 2.0))


static func level_for_experience(experience: int) -> int:
	var level = MAX_LEVEL
	while level >= MIN_LEVEL:
		if experience >= experience_for_level(level):
			break
		level -= 1
	
	return level


func init(level: int):
	stats.set_stat(StatTypes.Stat.LVL, level, false)
	stats.set_stat(StatTypes.Stat.EXP, experience_for_level(level), false)
