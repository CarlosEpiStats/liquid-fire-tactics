class_name AbilityMenuPanelController
extends Node

signal got_attack(info: Info)
signal got_defense(info: Info)
signal got_power(info: Info)
signal tweaked_damage(info: Info)
signal can_perform_checked(exc: BaseException)
signal failed()
signal did_perform()

const SHOWKEY := "Show"
const HIDEKEY := "Hide"
const ENTRYPOOLKEY := "AbilityMenuPanel.Entry"
const MENUCOUNT: int = 4

@export var entry_prefab: PackedScene
@export var title_label: Label
@export var panel: AbilityMenuPanel
@export var entry_vbox: VBoxContainer

var menu_entries: Array[AbilityMenuEntry] = []
var selection: int

func _ready() -> void:
	%PoolController.add_entry(ENTRYPOOLKEY, entry_prefab, MENUCOUNT, 2147483647)
	panel.set_position(HIDEKEY, false)
	_disable_node(panel)


func _disable_node(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_DISABLED
	node.hide()


func _enable_node(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_INHERIT
	node.show()


func show_panel(title: String, options: Array[String]):
	_enable_node(panel)
	clear()
	title_label.text = tr(title)
	for option in options:
		var entry: AbilityMenuEntry = dequeue()
		entry.title = tr(option)
		menu_entries.append(entry)
	
	set_selection(0)
	await panel.set_position(SHOWKEY, true)


func hide_panel():
	await panel.set_position(HIDEKEY, true)
	clear()
	
	# force panel to shrink before fitting to the correct size
	panel.size = Vector2.ZERO
	panel.set_position(HIDEKEY, false)
	
	_disable_node(panel)

func set_locked(index: int, value: bool):
	if index < 0 or index >= menu_entries.size():
		return
	
	menu_entries[index].is_locked = value
	if value and selection == index:
		next()


func next():
	if menu_entries.size() == 0:
		return
	
	for i in range(selection + 1, menu_entries.size() + 2):
		var index: int = i % menu_entries.size()
		if set_selection(index):
			break
	

func previous():
	if menu_entries.size() == 0:
		return
	
	for i in range(selection - 1 + menu_entries.size(), selection, -1):
		var index: int = i % menu_entries.size()
		if set_selection(index):
			break


func dequeue() -> AbilityMenuEntry:
	var p: Poolable = %PoolController.dequeue(ENTRYPOOLKEY)
	var entry: AbilityMenuEntry = p.get_node("Entry")
	
	if p.get_parent():
		p.get_parent().remove_child(p)
	
	entry_vbox.add_child(p)
	_enable_node(p)
	entry.reset()
	return entry


func enqueue(entry: AbilityMenuEntry):
	var p: Poolable = entry.get_parent()
	%PoolController.enqueue(p)


# Returns objects to the pool and cleans up the array
func clear():
	for i in range(menu_entries.size() - 1, -1, -1):
		enqueue(menu_entries[i])
	
	menu_entries.clear()


# Checks if an option is locked or out of bounds
func set_selection(value: int) -> bool:
	if menu_entries[value].is_locked:
		return false
	
	# Deselect the previously selected entry
	if selection >= 0 and selection < menu_entries.size():
		menu_entries[selection].is_selected = false
	
	selection = value
	
	# Select the new entry
	if selection >= 0 and selection < menu_entries.size():
		menu_entries[selection].is_selected = true
	
	return true
	
