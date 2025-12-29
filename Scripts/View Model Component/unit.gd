class_name Unit
extends Node3D

var tile: Tile
var dir: Directions.Dirs = Directions.Dirs.SOUTH

func place(target: Tile):
	# Make sure old tile location is not still pointing to this unit
	if tile != null and tile.content == self:
		tile.content = null
	
	# Link unit and tile references
	tile = target
	
	if target != null:
		target.content = self

func match_unit():
	self.position = tile.center()
	self.rotation_degrees = Directions.to_euler(dir)
