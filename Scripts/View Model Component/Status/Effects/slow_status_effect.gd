class_name SlowStatusEffect
extends StatusEffect

var my_stats: Stats
const SPEED_MODIFIER = 0.5

func _enter_tree():
	my_stats = self.get_parent().get_parent().get_node("Stats")
	if my_stats:
		my_stats.will_change_notification(StatTypes.Stat.CTR).connect(on_counter_will_change)


func _exit_tree():
	my_stats.will_change_notification(StatTypes.Stat.CTR).disconnect(on_counter_will_change)


func on_counter_will_change(sender: Stats, exc: ValueChangeException):
	exc.add_modifiers(MultDeltaModifier.new(0, SPEED_MODIFIER))
