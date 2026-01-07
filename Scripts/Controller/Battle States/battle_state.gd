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

var stat_panel_controller: StatPanelController:
	get:
		return _owner.stat_panel_controller

var pos: Vector2i:
	get:
		return _owner.board.pos

var board: BoardCreator:
	get:
		return _owner.board

var turn_controller: TurnOrderController:
	get:
		return _owner.turn_order_controller

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
	

func get_unit(p: Vector2i):
	var t: Tile = _owner.board.get_tile(p)
	if t == null or t.content == null:
		return null
	
	return t.content


func refresh_primary_stat_panel(p: Vector2i):
	var target: Unit = get_unit(p)
	if target != null:
		stat_panel_controller.show_primary(target)
	
	else: 
		stat_panel_controller.hide_primary()


func refresh_secondary_stat_panel(p: Vector2i):
	var target: Unit = get_unit(p)
	if target != null:
		stat_panel_controller.show_secondary(target)
	
	else:
		stat_panel_controller.hide_secondary()
