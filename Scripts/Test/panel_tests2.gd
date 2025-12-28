extends Node

@export var child_panel: LayoutAnchor
@export var vbox: VBoxContainer
@export var animated: bool
@export var anchor_list: Array[PanelAnchor] = []

func _ready():
	# Buttons
	var button_show = Button.new()
	button_show.text = "Show"
	button_show.pressed.connect(anchor_button.bind("Show"))
	vbox.add_child(button_show)
	
	var button_hide = Button.new()
	button_hide.text = "Hide"
	button_hide.pressed.connect(anchor_button.bind("Hide"))
	vbox.add_child(button_hide)
	
	var button_center = Button.new()
	button_center.text = "Center"
	button_center.pressed.connect(anchor_button.bind("Center"))
	vbox.add_child(button_center)
	
	# Add a new anchor to the list
	var anchor_center := PanelAnchor.new()
	anchor_center.set_values(
		"Center", 
		Control.PRESET_CENTER, 
		Control.PRESET_CENTER, 
		Vector2.ZERO, 0.5, 
		Tween.TRANS_BACK
	)
	anchor_list.append(anchor_center)


func anchor_button(text: String):
	var anchor = get_anchor(text)
	
	if anchor:
		child_panel.to_anchor_position(anchor, animated)
	
	else:
		print("Anchor is null")
