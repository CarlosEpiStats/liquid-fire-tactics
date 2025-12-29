extends BaseAbilityMenuState

@export var command_selection_state: State
@export var category_selection_state: State

static var category: int
var white_magic_options: Array[String] = ["Cure", "Raise"]
var black_magic_options: Array[String] = ["Fire", "Ice", "Lightning", "Poison"]

func load_menu():
	if category == 0:
		menu_title = "White Magic"
		set_options(white_magic_options)
	
	else:
		menu_title = "Black Magic"
		set_options(black_magic_options)
	
	ability_menu_panel_controller.show_panel(menu_title, menu_options)


func confirm():
	turn.has_unit_acted = true
	if turn.has_unit_moved:
		turn.lock_move = true
	
	_owner.state_machine.change_state(command_selection_state)


func cancel():
	_owner.state_machine.change_state(category_selection_state)


func set_options(options: Array[String]):
	menu_options.clear()
	for entry in options:
		menu_options.append(entry)
