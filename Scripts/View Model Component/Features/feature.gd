class_name Feature
extends Node

var target: Node:
	get:
		return _target

var _target: Node

func activate(target_obj: Node):
	if _target == null:
		_target = target_obj
		on_apply()


func deactivate():
	if _target != null:
		on_remove()
		_target = null


func apply(target_obj: Node):
	_target = target_obj
	on_apply()
	_target = null


func on_apply():
	pass


func on_remove():
	pass
