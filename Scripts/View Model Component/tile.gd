@tool # allows to change it from the editor
class_name Tile
extends Node

const STEP_HEIGHT := 0.25

var pos: Vector2i # integer vector
var height: int
var content: Node
var prev: Tile
var distance: int

# Convenience, get the value of the top edge, useful for placing things on top
func center() -> Vector3:
	return Vector3(pos.x, height * STEP_HEIGHT, pos.y)

# Scales to the correct height and move the tile half the height, 
# because the pivot point is at the center of the tile
func match_tile():
	self.scale = Vector3(1, height * STEP_HEIGHT, 1)
	self.position = Vector3(pos.x, height * STEP_HEIGHT / 2.0, pos.y)

func grow():
	height += 1
	match_tile()

func shrink():
	height -= 1
	match_tile()

# Set a specific height and position of a tile
func load_tile(p: Vector2i, h: int):
	pos = p
	height = h
	match_tile()

func load_vector(v: Vector3):
	load_tile(Vector2i(v.x, v.z), v.y)
