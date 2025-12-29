@tool
class_name BoardCreator
extends Node

@export var width: int = 10
@export var depth: int = 10
@export var height: int = 8
@export var pos: Vector2i
@export var file_name := "defaultMap.txt"

var _old_pos: Vector2i
var _random = RandomNumberGenerator.new()
var tiles = {}
var tile_view_prefab = preload("res://Prefabs/Tile.tscn")
var tile_selection_indicator_prefab = preload("res://Prefabs/Tile Selection Indicator.tscn")
var marker
var save_path = "res://Data/Levels/"
var selected_tile_color := Color(0, 1, 1, 1)
var default_tile_color := Color(1, 1, 1, 1)

func _ready() -> void:
	marker = tile_selection_indicator_prefab.instantiate()
	add_child(marker)
	pos = Vector2i.ZERO
	_old_pos = pos
	_random.randomize()

func _process(delta: float) -> void:
	if pos != _old_pos:
		_old_pos = pos
		_update_marker()

# Check if the tile has the current pos, and set the cursor on top
func _update_marker():
	if tiles.has(pos):
		var t: Tile = tiles[pos]
		marker.position = t.center()
	else:
		marker.position = Vector3(pos.x, 0, pos.y)

func clear():
	for key in tiles:
		tiles[key].free()
	tiles.clear()

func grow():
	_grow_single(pos)

func shrink():
	_shrink_single(pos)

func _grow_single(p: Vector2i):
	var t: Tile = _get_or_create(p)
	if t.height < height:
		t.grow()
		_update_marker()

# Does nothing if there's no tile, and shrinks it if there is one
func _shrink_single(p: Vector2i):
	if not tiles.has(p):
		return
	
	var t: Tile = tiles[p]
	t.shrink()
	_update_marker()
	
	if t.height <= 0:
		tiles.erase(p)
		t.free()

# Finds a tile in the dictionary and returns it, or creates a new one
func _get_or_create(p: Vector2i):
	if tiles.has(p):
		return tiles[p]
	
	var t: Tile = _create()
	t.load_tile(p, 0)
	tiles[p] = t
	
	return t

func _create():
	var instance = tile_view_prefab.instantiate()
	add_child(instance)
	return instance

func _random_rect():
	var x = _random.randi_range(0, width - 1)
	var y = _random.randi_range(0, depth - 1)
	var w = _random.randi_range(1, width - x)
	var h = _random.randi_range(1, depth - y)
	return Rect2i(x, y, w, h)

func grow_area():
	var r: Rect2i = _random_rect()
	_grow_rect(r)

func shrink_area():
	var r: Rect2i = _random_rect()
	_shrink_rect(r)

func _grow_rect(rect: Rect2i):
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			var p = Vector2i(x, y)
			_grow_single(p)

func _shrink_rect(rect: Rect2i):
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			var p = Vector2i(x, y)
			_shrink_single(p)

func save():
	var save_file = save_path + file_name
	save_map(save_file)


func load_file():
	var save_file = save_path + file_name
	load_map(save_file)


func save_json():
	#var save_file = save_path + file_name
	#var save_game = FileAccess.open(save_file, FileAccess.WRITE)
	var save_file = "res://Data/Levels/savegame.json"
	save_map_json(save_file)


func load_json():
	#var save_file = save_path + file_name
	#var save_game = FileAccess.open(save_file, FileAccess.WRITE)
	var save_file = "res://Data/Levels/savegame.json"
	load_map_json(save_file)


func save_map(save_file):
	var save_game = FileAccess.open(save_file, FileAccess.WRITE)
	var version = 1
	var size = tiles.size()
	
	save_game.store_8(version)
	save_game.store_16(size)
	
	for key in tiles:
		save_game.store_8(key.x)
		save_game.store_8(key.y)
		save_game.store_8(tiles[key].height)
		
	save_game.close()

func load_map(save_file):
	clear()
	
	if not FileAccess.file_exists(save_file):
		return # Error! We don't have a save to load.
		
	var save_game = FileAccess.open(save_file, FileAccess.READ)
	var version = save_game.get_8()
	var size = save_game.get_16()
	
	for i in range(size):
		var save_x = save_game.get_8()
		var save_z = save_game.get_8()
		var save_height = save_game.get_8()
		
		var t: Tile = _create()
		t.load_tile(Vector2i(save_x, save_z) , save_height)
		tiles[Vector2i(t.pos.x,t.pos.y)] = t
	
	save_game.close()
	_update_marker()

func save_map_json(save_file):
	var main_dict = {
		"version": "1.0.0",
		"tiles": []
	}
		
	for key in tiles:
		var save_dict = {
			"pos_x" : tiles[key].pos.x,
			"pos_z" : tiles[key].pos.y,
			"height" : tiles[key].height
			}
		main_dict["tiles"].append(save_dict)
	
	var save_game = FileAccess.open(save_file, FileAccess.WRITE)
	
	var json_string = JSON.stringify(main_dict, "\t", false)
	save_game.store_line(json_string)

func load_map_json(save_file):
	clear()

	if not FileAccess.file_exists(save_file):
		return # Error! We don't have a save to load.
	
	var save_game = FileAccess.open(save_file, FileAccess.READ)

	var json_text = save_game.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(json_text)

	if parse_result != OK:
		print("Error %s reading json file." % parse_result)
		return
		
	var data = {}
	data = json.get_data()

	for mtile in data["tiles"]:
		var t: Tile = _create()
		t.load_tile(Vector2(mtile["pos_x"], mtile["pos_z"]) , mtile["height"])
		tiles[Vector2i(t.pos.x,t.pos.y)] = t
	
	save_game.close()
	_update_marker()

# Pathfinding
func clear_search():
	for key in tiles:
		tiles[key].prev = null
		tiles[key].distance = 2147483647 # max signed 32bit number

func get_tile(p: Vector2i):
	return tiles[p] if tiles.has(p) else null
	

func search(start: Tile, add_tile: Callable):
	var ret_value = []
	ret_value.append(start)	
	clear_search()
	var check_next = []
	
	start.distance = 0
	check_next.push_back(start)

	var _dirs = [Vector2i(0,1), Vector2i(0,-1), Vector2i(1,0), Vector2i(-1,0)]
	
	while check_next.size() > 0:
		var t: Tile = check_next.pop_front()
		_dirs.shuffle() # Optional. May impact performance
		
		for i in _dirs.size():
			var next: Tile = get_tile(t.pos + _dirs[i])
			if next == null or next.distance <= t.distance + 1:
				continue
			if add_tile.call(t, next):
				next.distance = t.distance + 1
				next.prev = t
				check_next.push_back(next)
				ret_value.append(next)
	
	return ret_value

# Second search method that avoids drawbacks like gaps or units blocking the path
# Used for Fly Movement
func range_search(start: Tile, add_tile: Callable, range: int):
	var ret_value = []
	clear_search()
	start.distance = 0
	
	for y in range(-range, range+1):
		for x in range(-range + abs(y), range - abs(y) +1):
			var next: Tile = get_tile(start.pos + Vector2i(x, y))
			if next == null:
				continue
				
			if next == start:
				ret_value.append(start)
			
			elif add_tile.call(start, next):
				next.distance = (abs(x) + abs(y))
				next.prev = start
				ret_value.append(next)
	
	return ret_value

func select_tiles(tile_list: Array):
	for i in tile_list.size():
		tile_list[i].get_node("MeshInstance3D").material_override.albedo_color = selected_tile_color

func deselect_tiles(tile_list: Array):
	for i in tile_list.size():
		tile_list[i].get_node("MeshInstance3D").material_override.albedo_color = default_tile_color
