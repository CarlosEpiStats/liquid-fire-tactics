class_name DurationStatusCondition
extends StatusCondition

var duration: int = 10
var turn_controller

func _ready():
	turn_controller = get_node("/root/Battle/Battle Controller/TurnOrderController")
	turn_controller.round_began.connect(on_new_turn)


func _exit_tree():
	turn_controller.round_began.disconnect(on_new_turn)


func on_new_turn():
	duration -= 1
	if duration <= 0:
		remove()
