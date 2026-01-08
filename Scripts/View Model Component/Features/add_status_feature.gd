class_name AddStatusFeature
extends Feature

var status_effect: GDScript
var status_string: String
var condition_string: String
var condition: StatusCondition

func on_apply():
	var status: Status = self.get_parent().get_parent().get_parent().get_node("Status")
	condition = status.add(status_effect, StatusCondition, status_string, condition_string)
	

func on_remove():
	if condition:
		condition.remove()
