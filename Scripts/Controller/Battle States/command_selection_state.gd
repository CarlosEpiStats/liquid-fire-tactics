extends BaseAbilityMenuState

@export var move_target_state: State
@export var category_selection_state: State
@export var select_unit_state: State
@export var explore_state: State

func load_menu():
	if menu_options.size() == 0:
		menu_title = "Commands"
		menu_options.append("Move")
		menu_options.append("Action")
		menu_options.append("Wait")
	
	ability_menu_panel_controller.show_panel(menu_title, menu_options)
	ability_menu_panel_controller.set_locked(0, turn.has_unit_moved)
	ability_menu_panel_controller.set_locked(1, turn.has_unit_acted)


func confirm():
	match(ability_menu_panel_controller.selection):
		0:
			_owner.state_machine.change_state(move_target_state)
		1:
			_owner.state_machine.change_state(category_selection_state)
		2:
			_owner.state_machine.change_state(select_unit_state)


func cancel():
	if turn.has_unit_moved and not turn.lock_move:
		turn.undo_move()
		ability_menu_panel_controller.set_locked(0, false)
		select_tile(turn.actor.tile.pos)
	
	else:
		_owner.state_machine.change_state(explore_state)
