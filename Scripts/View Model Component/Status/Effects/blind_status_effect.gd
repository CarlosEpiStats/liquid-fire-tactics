class_name BlindStatusEffect
extends StatusEffect

var hit_indicator: HitSuccessIndicator

func _enter_tree() -> void:
	hit_indicator = get_node("/root/Battle/Battle Controller/HitSuccessIndicator")
	if hit_indicator:
		hit_indicator.status_checked.connect(on_hit_rate_status_check)


func _exit_tree() -> void:
	hit_indicator.status_checked.disconnect(on_hit_rate_status_check)


func on_hit_rate_status_check(info: Info):
	var _owner: Unit = get_parent_unit(self)
	if _owner == info.attacker:
		info.data = info.data + 50
	
	elif _owner == info.target:
		info.data = info.data - 20


func get_parent_unit(node: Node):
	var parent = node.get_parent()
	if parent == null:
		return null
	
	if parent is Unit:
		return parent
	
	return get_parent_unit(parent)
