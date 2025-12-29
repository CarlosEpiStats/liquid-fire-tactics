class_name BaseAbilityMenuState
extends BattleState

var menu_title: String
var menu_options: Array[String] = []

func enter():
	super()
	select_tile(turn.actor.tile.pos)
	await load_menu()


func exit():
	super()
	await ability_menu_panel_controller.hide()


func on_fire(e: int):
	if e == 0:
		confirm()
	
	else:
		cancel()


func on_move(e: Vector2i):
	if e.x > 0 and e.y > 0:
		ability_menu_panel_controller.next()
	
	else:
		ability_menu_panel_controller.previous()


func load_menu():
	pass


func confirm():
	pass


func cancel():
	pass
