class_name Directions

enum Dirs {
	SOUTH,
	EAST,
	NORTH,
	WEST,
}


static func get_direction(t1: Tile, t2: Tile):
	var dir: Directions.Dirs
	var to_tile: Vector2i = t1.pos - t2.pos
	if abs(to_tile.x) > abs(to_tile.y):
		dir = Directions.Dirs.EAST if to_tile.x < 0 else Directions.Dirs.WEST
	else:
		dir = Directions.Dirs.SOUTH if to_tile.y < 0 else Directions.Dirs.NORTH
	
	return dir


static func to_euler(d: Dirs):
	return Vector3(0, d * 90, 0)


static func to_vector(d: Dirs):
	# SOUTH, EAST, NORTH, WEST
	var _dirs = [Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, 0)]
	return _dirs[d]


static func to_dir(p: Vector2i):
	if p.y < 0:
		return Dirs.NORTH
	
	if p.x < 0:
		return Dirs.WEST
	
	if p.y > 0:
		return Dirs.SOUTH
	
	return Dirs.EAST
