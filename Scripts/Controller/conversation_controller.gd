class_name ConversationController
extends Node

signal completed_event
signal resumed

@export var left_panel: ConversationPanel
@export var right_panel: ConversationPanel
var in_transition: bool

func _ready() -> void:
	left_panel.to_anchor_position(left_panel.get_the_anchor("Hide Bottom"), false)
	_disable_node(left_panel)
	
	right_panel.to_anchor_position(right_panel.get_the_anchor("Hide Bottom"), false)
	_disable_node(right_panel)

func _disable_node(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_DISABLED
	node.hide()


func _enable_node(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_INHERIT
	node.show()


func show_conversation(data: ConversationData):
	_enable_node(left_panel)
	_enable_node(right_panel)
	sequence(data)


func next():
	if not in_transition:
		resumed.emit()


func sequence(data: ConversationData):
	for sd in data.list:
		in_transition = true
		var current_panel: ConversationPanel
		var show: PanelAnchor
		var hide: PanelAnchor
		
		if sd.anchor in [Control.PRESET_TOP_LEFT, Control.PRESET_BOTTOM_LEFT, Control.PRESET_CENTER_LEFT]:
			current_panel = left_panel
		
		else:
			current_panel = right_panel
		
		if sd.anchor in [Control.PRESET_TOP_LEFT, Control.PRESET_TOP_RIGHT, Control.PRESET_CENTER_TOP]:
			show = current_panel.get_the_anchor("Show Top")
			hide = current_panel.get_the_anchor("Hide Top")
		
		else:
			show = current_panel.get_the_anchor("Show Bottom")
			hide = current_panel.get_the_anchor("Hide Bottom")
		
		# Make sure panel is hidden to start and set text to initial dialog
		current_panel.to_anchor_position(hide, false)
		current_panel.display(sd)
		
		# Move panel and wait for it to finish moving
		await current_panel.to_anchor_position(show, true)
		
		# once panel is done moving we can start accepting clicks to advance dialog
		in_transition = false
		await current_panel.finished
		
		# hide panel and wait for it to get off screen
		in_transition = true
		await current_panel.to_anchor_position(hide, true)
	
	_disable_node(left_panel)
	_disable_node(right_panel)
	completed_event.emit()
