class_name HitRate
extends Node

var hit_indicator: HitSuccessIndicator

func _ready() -> void:
	hit_indicator = get_node("/root/Battle/Battle Controller/HitSuccessIndicator")


func calculate(attacker: Unit, target: Unit):
	pass


func automatic_hit(attacker: Unit, target: Unit) -> bool:
	var exc := MatchException.new(attacker, target)
	hit_indicator.automatic_hit_checked.emit(exc)
	return exc.toggle


func automatic_miss(attacker: Unit, target: Unit) -> bool:
	var exc := MatchException.new(attacker, target)
	hit_indicator.automatic_miss_checked.emit(exc)
	return exc.toggle


func adjust_for_status_effect(attacker: Unit, target: Unit, rate: int) -> int:
	var args := Info.new(attacker, target, rate)
	hit_indicator.status_checked.emit(args)
	return args.data


func final(evade: int):
	return 100 - evade
