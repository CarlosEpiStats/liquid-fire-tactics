class_name Turn
extends Node

var actor: Unit
var has_unit_moved: bool
var has_unit_acted: bool
var lock_move: bool
var start_tile: Tile
var start_dir: Directions.Dirs

func change(current: Unit):
	actor = current
	has_unit_moved = false
	has_unit_acted = false
	lock_move = false
	start_tile = actor.tile
	start_dir = actor.dir


func undo_move():
	has_unit_moved = false
	actor.place(start_tile)
	actor.dir = start_dir
	actor.match_unit()
