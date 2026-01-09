class_name Ability
extends Node

var battle: BattleController
var ability_controller: AbilityMenuPanelController

func _ready() -> void:
	battle = get_tree().root.get_node("Battle/Battle Controller")
	ability_controller = battle.ability_menu_panel_controller


func can_perform():
	var exc := BaseException.new(true)
	ability_controller.can_perform_checked.emit(exc)
	return exc.toggle


func perform(targets: Array[Tile]):
	if not can_perform():
		ability_controller.failed.emit()
		return
	
	for target in targets:
		_perform(target)
		
	ability_controller.did_perform.emit()


func _perform(target: Tile):
	var children: Array[Node] = self.find_children("*", "BaseAbilityEffect", false)
	for child in children:
		var effect: BaseAbilityEffect = child as BaseAbilityEffect
		effect.apply(target)
