class_name StatusCondition
extends Node

func remove():
	var status: Status = self.get_parent().get_parent()
	if status:
		status.remove(self)
