class_name HitRate
extends Node

var hit_indicator: HitSuccessIndicator
var attacker: Unit

func _ready() -> void:
	var battle: BattleController = get_node("/root/Battle/Battle Controller")
	hit_indicator = battle.get_node("HitSuccessIndicator")
	attacker = battle.get_parent_unit(self)


func calculate(target: Tile):
	pass


func automatic_hit(target: Unit) -> bool:
	var exc := MatchException.new(attacker, target)
	hit_indicator.automatic_hit_checked.emit(exc)
	return exc.toggle


func automatic_miss(target: Unit) -> bool:
	var exc := MatchException.new(attacker, target)
	hit_indicator.automatic_miss_checked.emit(exc)
	return exc.toggle


func adjust_for_status_effect(target: Unit, rate: int) -> int:
	var args := Info.new(attacker, target, rate)
	hit_indicator.status_checked.emit(args)
	return args.data


func final(evade: int):
	return 100 - evade


func roll_for_hit(target: Tile):
	var roll: int = randi_range(0, 100)
	var chance: int = calculate(target)
	return roll <= chance
