extends State
class_name BattleState

var _owner: BattleController
var ability_menu_panel_controller: AbilityMenuPanelController:
	get:
		return _owner.ability_menu_panel_controller

var turn: Turn:
	get:
		return _owner.turn

var units: Array[Unit]:
	get:
		return _owner.units

func _ready():
	_owner = get_node("../../")

func add_listeners():
	_owner.input_controller.move_event.connect(on_move)
	_owner.input_controller.fire_event.connect(on_fire)
	_owner.input_controller.quit_event.connect(on_quit)
	_owner.input_controller.camera_zoom_event.connect(zoom)
	_owner.input_controller.camera_rotate_event.connect(orbit)


func remove_listeners():
	_owner.input_controller.move_event.disconnect(on_move)
	_owner.input_controller.fire_event.disconnect(on_fire)
	_owner.input_controller.quit_event.disconnect(on_quit)
	_owner.input_controller.camera_zoom_event.disconnect(zoom)
	_owner.input_controller.camera_rotate_event.disconnect(orbit)


func on_move(e: Vector2i):
	pass

func on_fire(e: int):
	pass

func select_tile(p: Vector2i):
	if _owner.board.pos == p:
		return
	
	_owner.board.pos = p
	
func on_quit():
	get_tree().quit()

func zoom(scroll: int):
	pass

func orbit(direction: Vector2):
	pass
