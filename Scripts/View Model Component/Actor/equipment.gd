class_name Equipment
extends Node

signal equipped_notification()
signal unequipped_notification()

var _items: Array[Equippable]

func equip(item: Equippable, slots: EquipSlots.Slot):
	unequip_slots(slots)
	_items.append(item)
	var item_parent: Node = item.get_parent()
	self.add_child(item_parent)
	item.slots = slots
	item.on_equip()
	equipped_notification.emit(self, item)


func unequip_item(item: Equippable):
	item.on_unequip()
	item.slots = EquipSlots.Slot.NONE
	_items.erase(item)
	var item_parent: Node = item.get_parent()
	self.remove_child(item_parent)
	unequipped_notification.emit(self, item)


func unequip_slots(slots: EquipSlots.Slot):
	for i in range(_items.size() -1, -1, -1):
		var item = _items[i]
		if (item.slots & slots) != EquipSlots.Slot.NONE:
			unequip_item(item)
