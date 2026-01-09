class_name Info
extends Node

var _attacker: Unit
var _target: Unit

var data

var attacker: Unit:
	get:
		return _attacker

var target: Unit:
	get:
		return _target

func _init(unit_a: Unit, unit_b: Unit, arg):
	_attacker = unit_a
	_target = unit_b
	data = arg
