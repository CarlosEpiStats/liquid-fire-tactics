class_name StatPanelController
extends Node

const SHOWKEY := "Show"
const HIDEKEY := "Hide"

@export var primary_panel: StatPanel
@export var secondary_panel: StatPanel

var primary_showing: bool
var secondary_showing: bool

func _ready() -> void:
	primary_panel.to_anchor_position(primary_panel.get_anchor(HIDEKEY), false)
	primary_showing = false
	secondary_panel.to_anchor_position(secondary_panel.get_anchor(HIDEKEY), false)
	secondary_showing = false


func show_primary(obj: Node):
	primary_panel.display(obj)
	if not primary_showing:
		primary_showing = true
		await primary_panel.set_position(SHOWKEY, true)


func hide_primary():
	if primary_showing:
		primary_showing = false
		await primary_panel.set_position(HIDEKEY, true)


func show_secondary(obj: Node):
	secondary_panel.display(obj)
	if not secondary_showing:
		secondary_showing = true
		await secondary_panel.set_position(SHOWKEY, true)


func hide_secondary():
	if secondary_showing:
		secondary_showing = false
		await secondary_panel.set_position(HIDEKEY, true)
