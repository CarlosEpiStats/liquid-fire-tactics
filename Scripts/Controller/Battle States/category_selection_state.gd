extends BaseAbilityMenuState

@export var command_selection_state: State
@export var action_selection_state: State

func load_menu():
	if menu_options.size() == 0:
		menu_title = "Action"
		menu_options.append("Attack")
		menu_options.append("White Magic")
		menu_options.append("Black Magic")
	
	ability_menu_panel_controller.show_panel(menu_title, menu_options)


func confirm():
	match(ability_menu_panel_controller.selection):
		0:
			attack()
		1:
			set_category(0)
		2:
			set_category(1)


func cancel():
	_owner.state_machine.change_state(command_selection_state)


func attack():
	turn.has_unit_acted = true
	if turn.has_unit_moved:
		turn.lock_move = true
	
	_owner.state_machine.change_state(command_selection_state)


func set_category(index: int):
	action_selection_state.category = index
	_owner.state_machine.change_state(action_selection_state)


func enter():
	super()
	stat_panel_controller.show_primary(turn.actor)


func exit():
	super()
	await stat_panel_controller.hide_primary()
