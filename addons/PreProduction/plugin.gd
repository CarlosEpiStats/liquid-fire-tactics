@tool
extends EditorPlugin

var panel
const TOOL_PANEL = preload("res://addons/PreProduction/pre_production.tscn")

func _enter_tree() -> void:
	panel = TOOL_PANEL.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UR, panel)
	

func _exit_tree() -> void:
	remove_control_from_docks(panel)
	panel.queue_free()
