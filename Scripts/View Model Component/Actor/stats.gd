class_name Stats
extends Node

var _data: Array[int] = []
var _will_change_notifications = {}
var _did_change_notifications = {}

func _init() -> void:
	_data.resize(StatTypes.Stat.size())
	_data.fill(0)


func get_stat(stat_type: StatTypes.Stat):
	return _data[stat_type]


func set_stat(stat_type: StatTypes.Stat, value: int, allow_exceptions: bool = true):
	var old_value: int = _data[stat_type]
	if old_value == value:
		return
		
	if allow_exceptions:
		# Allow exceptions to the rule here
		var exc: ValueChangeException = ValueChangeException.new(old_value, value)
		
		# The notification is unique per stat type
		will_change_notification(stat_type).emit(self, exc)
		
		# Did anything modify the value?
		value = floori(exc.get_modified_value())
		
		# Did something nullify the change?
		if exc.toggle == false or value == old_value:
			return
	
	_data[stat_type] = value
	did_change_notification(stat_type).emit(self, old_value)


func will_change_notification(stat_type: StatTypes.Stat):
	var stat_name = StatTypes.Stat.keys()[stat_type]
	
	if not _will_change_notifications.has(stat_name):
		self.add_user_signal(stat_name + "_will_change")
		_will_change_notifications[stat_name] = Signal(self, stat_name + "_will_change")
	
	return _will_change_notifications[stat_name]


func did_change_notification(stat_type: StatTypes.Stat):
	var stat_name = StatTypes.Stat.keys()[stat_type]
	
	if not _did_change_notifications.has(stat_name):
		self.add_user_signal(stat_name + "_did_change")
		_did_change_notifications[stat_name] = Signal(self, stat_name + "_did_change")
	
	return _did_change_notifications[stat_name]
