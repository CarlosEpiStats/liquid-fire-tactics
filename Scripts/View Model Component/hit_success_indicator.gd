class_name HitSuccessIndicator
extends Node

signal automatic_hit_checked
signal automatic_miss_checked
signal status_checked

@export var anchor_list: Array[PanelAnchor] = []
@export var panel: LayoutAnchor
@export var arrow: TextureProgressBar
@export var label: Label

func _ready() -> void:
	set_position("Hide", false)
	

func set_stats(chance: int, amount: int):
	arrow.value = chance
	label.text = "{0}% {1}pt(s)".format([chance, amount])
	

func show_panel():
	set_position("Show", true)


func hide_panel():
	set_position("Hide", true)


func set_position(anchor_name: String, animated: bool):
	var anchor = get_anchor(anchor_name)
	await panel.to_anchor_position(anchor, animated)


func get_anchor(anchor_name: String):
	for anchor in self.anchor_list:
		if anchor.anchor_name == anchor_name:
			return anchor
	
	return null
