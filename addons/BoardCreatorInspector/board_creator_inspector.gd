@tool
extends EditorInspectorPlugin

func _can_handle(object: Object) -> bool:
	if object is BoardCreator:
		return true
	return false

func _parse_begin(object: Object) -> void:
	var btn_clear = Button.new()
	btn_clear.set_text("Clear")
	btn_clear.pressed.connect(object.clear)
	add_custom_control(btn_clear)
	
	var btn_grow = Button.new()
	btn_grow.set_text("Grow")
	btn_grow.pressed.connect(object.grow)
	add_custom_control(btn_grow)
	
	var btn_shrink = Button.new()
	btn_shrink.set_text("Shrink")
	btn_shrink.pressed.connect(object.shrink)
	add_custom_control(btn_shrink)
	
	var btn_grow_area = Button.new()
	btn_grow_area.set_text("Grow Area")
	btn_grow_area.pressed.connect(object.grow_area)
	add_custom_control(btn_grow_area)
	
	var btn_shrink_area = Button.new()
	btn_shrink_area.set_text("Shrink Area")
	btn_shrink_area.pressed.connect(object.shrink_area)
	add_custom_control(btn_shrink_area)
	
	var btn_save = Button.new()
	btn_save.set_text("Save")
	btn_save.pressed.connect(object.save)
	add_custom_control(btn_save)
	
	var btn_load = Button.new()
	btn_load.set_text("Load")
	btn_load.pressed.connect(object.load_file)
	add_custom_control(btn_load)

	var btn_save_json = Button.new()
	btn_save_json.set_text("Save JSON")
	btn_save_json.pressed.connect(object.save_json)
	add_custom_control(btn_save_json)
	
	var btn_load_json = Button.new()
	btn_load_json.set_text("Load JSON")
	btn_load_json.pressed.connect(object.load_json)
	add_custom_control(btn_load_json)
