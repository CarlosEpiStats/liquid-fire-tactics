class_name AbilityMenuEntry
extends Node

# Possible states, breaking down each binary digit as a separate flag
# so it can hold multiple states at the single time
enum States {
	NONE = 0, # 0000
	SELECTED = 1 << 0, # 0001, 0th position set to 1
	LOCKED = 1 << 1, # 0010, 1st position set to 1
}

@export var bullet: TextureRect
@export var label: Label
@export var normal_sprite: Texture2D
@export var selected_sprite: Texture2D
@export var disabled_sprite: Texture2D

var _state: States
var state: States:
	get:
		return _state
	
	set(value):
		_state = value
		
		var font_color: String = "theme_override_colors/font_color"
		var font_outline_color: String = "theme_override_colors/font_outline_color"
		
		if is_locked:
			bullet.texture = disabled_sprite
			label.set(font_color, Color.SLATE_GRAY)
			label.set(font_outline_color, Color(0.078431, 0.141176, 0.172549)) #rgb:20, 36, 44
		
		elif is_selected:
			bullet.texture = selected_sprite
			label.set(font_color, Color(0.976470, 0.823529, 0.462745)) #rgb:249, 210, 118
			label.set(font_outline_color, Color(1.0, 0.627450, 0.282352)) #rgb:255, 160, 72
		
		else:
			bullet.texture = normal_sprite
			label.set(font_color, Color.WHITE)
			label.set(font_outline_color, Color(0.078431, 0.141176, 0.172549)) #rgb:20, 36, 44


# Bitwise operators to isolate the relevant binary bits and return or set only those pieces
# from the _state variable
var is_locked: bool:
	get:
		return (state & States.LOCKED) != States.NONE
	
	set(value):
		if value:
			state |= States.LOCKED
		
		else:
			state &= ~States.LOCKED


var is_selected: bool:
	get:
		return (state & States.SELECTED) != States.NONE
	
	set(value):
		if value:
			state |= States.SELECTED
		
		else:
			state &= ~States.SELECTED
			

# Get and set the value on our entry label
var title: String:
	get:
		return label.text
	
	set(value):
		label.text = value


# Return our enum to its default
func reset():
	state = States.NONE
