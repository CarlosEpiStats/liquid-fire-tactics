extends Node

var step: int = 0
var cursed_unit: Unit
var cursed_item: Equippable

func _ready() -> void:
	var turn_controller = get_node("/root/Battle/Battle Controller/TurnOrderController")
	turn_controller.turn_checked.connect(on_turn_check)


func on_turn_check(target: Unit, exc: BaseException):
	if not exc.toggle:
		return
	
	match step:
		0:
			equip_cursed_item(target)
		
		1:
			add(target, "Slow", SlowStatusEffect, 15)
		
		2:
			add(target, "Stop", StopStatusEffect, 15)
		
		3:
			add(target, "Haste", HasteStatusEffect, 15)
		
		_:
			unequip_cursed_item(target)
			print("[DEBUG] step incremented to", step)
	
	step += 1


func add(target: Unit, effect_name: String, effect: GDScript, duration: int):
	var status: Status = target.get_node("Status")
	var condition: DurationStatusCondition
	condition = status.add(effect, DurationStatusCondition, effect_name, "Duration Condition")
	condition.duration = 15


func equip_cursed_item(target: Unit):
	cursed_unit = target
	var obj = Node.new()
	obj.name = "Cursed Sword"
	
	var poison_feature = AddPoisonStatusFeature.new()
	poison_feature.name = "Poison Feature"
	obj.add_child(poison_feature)
	
	cursed_item = Equippable.new()
	cursed_item.name = "Equippable"
	obj.add_child(cursed_item)
	
	var equipment: Equipment = target.get_node("Equipment")
	equipment.equip(cursed_item, EquipSlots.Slot.PRIMARY)
	

func unequip_cursed_item(target: Unit):
	if target != cursed_unit or step < 10:
		return
	
	var equipment: Equipment = target.get_node("Equipment")
	equipment.unequip_item(cursed_item)
	cursed_item.queue_free()
	
	# Once cursed item is removed, we don't need this script anymore
	self.queue_free()
