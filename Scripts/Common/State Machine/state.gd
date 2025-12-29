class_name State
extends Node

func enter():
	add_listeners()

func exit():
	remove_listeners()

func _exit_tree() -> void:
	remove_listeners()

func add_listeners():
	pass

func remove_listeners():
	pass
