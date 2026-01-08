class_name AddPoisonStatusFeature
extends AddStatusFeature

func _ready() -> void:
	status_effect = PoisonStatusEffect
	status_string = "Poison"
	condition_string = "Status Condition"
