class_name StopStatusEffect
extends StatusEffect

var my_stats: Stats
var hit_indicator: HitSuccessIndicator

func _enter_tree():
	my_stats = self.get_parent().get_parent().get_node("Stats")
	if my_stats:
		my_stats.will_change_notification(StatTypes.Stat.CTR).connect(on_counter_will_change)
	
	hit_indicator = get_node("/root/Battle/Battle Controller/HitSuccessIndicator")
	if hit_indicator:
		hit_indicator.automatic_hit_checked.connect(on_automatic_hit_check)

func _exit_tree():
	my_stats.will_change_notification(StatTypes.Stat.CTR).disconnect(on_counter_will_change)


func on_counter_will_change(sender: Stats, exc: ValueChangeException):
	exc.flip_toggle()


func on_automatic_hit_check(exc: MatchException):
	var _owner: Unit = get_parent_unit(self)
	if _owner == exc.target:
		exc.flip_toggle()


func get_parent_unit(node: Node):
	var parent = node.get_parent()
	if parent == null:
		return null
	
	if parent is Unit:
		return parent
	
	return get_parent_unit(parent)
