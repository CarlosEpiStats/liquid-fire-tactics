class_name Equippable
extends Node

var default_slots: EquipSlots.Slot
var secondary_slots: EquipSlots.Slot
var slots: EquipSlots.Slot

var _is_equipped: bool

func on_equip():
	if _is_equipped:
		return
	
	_is_equipped = true
	
	var features: Array[Node] = self.get_parent().get_children()
	var filtered_array = features.filter(func(node): return node is Feature)
	for node in filtered_array:
		node.activate(self.get_parent().get_parent().get_parent())


func on_unequip():
	if not _is_equipped:
		return
	
	_is_equipped = false
	
	var features: Array[Node] = self.get_parent().get_children()
	var filtered_array = features.filter(func(node): return node is Feature)
	for node in filtered_array:
		node.deactivate()
