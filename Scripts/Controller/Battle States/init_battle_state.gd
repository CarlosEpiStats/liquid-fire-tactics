extends BattleState
@export var cut_scene_state: State

func enter():
	super()
	init()


func init():
	var save_file = _owner.board.save_path + _owner.board.file_name
	_owner.board.load_map(save_file)
	var p:Vector2i = _owner.board.tiles.keys()[0]
	select_tile(p)
	spawn_test_units()
	_owner.camera_controller.set_follow(_owner.board.marker)
	
	#TranslationServer.set_locale("ja")
	#TranslationServer.set_locale("en")
	TranslationServer.set_locale("es")
	
	_owner.state_machine.change_state(cut_scene_state)

func spawn_test_units():
	var components = [WalkMovement, FlyMovement, TeleportMovement]
	for i in components.size():
		var unit: Unit = _owner.hero_prefab.instantiate()
		_owner.add_child(unit)
		
		var p := Vector2i(_owner.board.tiles.keys()[i].x, _owner.board.tiles.keys()[i].y)

		unit.place(_owner.board.get_tile(p))
		unit.match_unit()
		
		var m = unit.get_node("Movement")
		m.set_script(components[i])
		m.range = 5
		m.jump_height = 1
		m.set_process(true)
		
		units.append(unit)
