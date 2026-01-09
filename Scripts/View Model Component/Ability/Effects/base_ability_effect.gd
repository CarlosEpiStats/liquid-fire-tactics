class_name BaseAbilityEffect
extends Node

const MIN_DAMAGE: int = -999
const MAX_DAMAGE: int = 999

var battle: BattleController
var ability_controller: AbilityMenuPanelController
var hit_controller: HitSuccessIndicator

func _ready() -> void:
	battle = get_tree().root.get_node("Battle/Battle Controller")
	ability_controller = battle.ability_menu_panel_controller
	hit_controller = battle.hit_success_indicator


func predict(target: Tile):
	pass


func apply(target: Tile):
	if self.get_node("AbilityEffectTarget").is_target(target) == false:
		return
	
	if self.get_node("HitRate").roll_for_hit(target):
		print("Hit")
		hit_controller.hit.emit(on_apply(target))
	
	else:
		print("Missed")
		hit_controller.missed.emit()
	

func on_apply(target: Tile):
	pass


func get_stat(attacker: Unit, target: Unit, notifier: Signal, start_value: int):
	var mods: Array[ValueModifier]
	var info = Info.new(attacker, target, mods)
	notifier.emit(info)
	
	mods.sort_custom(func(a, b): return a.sort_order < b.sort_order)
	
	var value: float = start_value
	for mod in mods:
		value = mod.modify(start_value, value)
	
	var ret_value: int = floori(value)
	ret_value = clamp(ret_value, MIN_DAMAGE, MAX_DAMAGE)
	return ret_value
