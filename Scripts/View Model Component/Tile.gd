@tool # allows to change it from the editor
extends Node
class_name Tile

const stepHeight: float = 0.25
var pos: Vector2i # integer vector
var height: int
var content: Node
var prev: Tile
var distance: int

# Convenience, get the value of the top edge, useful for placing things on top
func center() -> Vector3:
	return Vector3(pos.x, height * stepHeight, pos.y)

# Scales to the correct height and move the tile half the height, 
# because the pivot point is at the center of the tile
func Match():
	self.scale = Vector3(1, height * stepHeight, 1)
	self.position = Vector3(pos.x, height * stepHeight / 2.0, pos.y)

func Grow():
	height += 1
	Match()

func Shrink():
	height -= 1
	Match()

# Set a specific height and position of a tile
func Load(p: Vector2i, h: int):
	pos = p
	height = h
	Match()

func LoadVector(v: Vector3):
	Load(Vector2i(v.x, v.z), v.y)
