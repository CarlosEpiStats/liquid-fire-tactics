extends Node

var inventory: Array[Node] = []
var combatants: Array[Node] = []
var _random = RandomNumberGenerator.new()

func _ready() -> void:
	_random.randomize()
	create_items()
	create_combatants()
	await simulate_battle()


func on_equipped_item(eq: Equipment, item: Equippable):
	inventory.erase(item.get_parent())
	var message: String = "{0} equipped {1}".format([eq.get_parent().name, item.get_parent().name])
	print(message)


func on_unequipped_item(eq: Equipment, item: Equippable):
	inventory.append(item.get_parent())
	var message: String = "{0} unequipped {1}".format([eq.get_parent().name, item.get_parent().name])
	print(message)


func create_item(title: String, type: StatTypes.Stat, amount: int):
	var item: Node = Node.new()
	item.name = title
	var smf: StatModifierFeature = StatModifierFeature.new()
	smf.name = "SMF"
	smf.type = type
	smf.amount = amount
	item.add_child(smf)
	return item


func create_consumable_item(title: String, type: StatTypes.Stat, amount: int):
	var item: Node = create_item(title, type, amount)
	var consumable: Consumable = Consumable.new()
	consumable.name = "Consumable"
	item.add_child(consumable)
	return item
	

func create_equippable_item(title: String, type: StatTypes.Stat, amount: int, slot: EquipSlots.Slot):
	var item: Node = create_item(title, type, amount)
	var equip = Equippable.new()
	equip.name = "Equippable"
	equip.default_slots = slot
	item.add_child(equip)
	return item


func create_hero():
	var actor: Node = create_actor("Hero")
	var equipment = Equipment.new()
	equipment.name = "Equipment"
	equipment.equipped_notification.connect(on_equipped_item)
	equipment.unequipped_notification.connect(on_unequipped_item)
	actor.add_child(equipment)
	return actor


func create_actor(title: String):
	var actor: Node = Node.new()
	actor.name = title
	self.add_child(actor)
	var s := Stats.new()
	s.name = "Stats"
	actor.add_child(s)
	s.set_stat(StatTypes.Stat.MHP, _random.randi_range(500, 1000))
	s.set_stat(StatTypes.Stat.HP, s.get_stat(StatTypes.Stat.MHP))
	s.set_stat(StatTypes.Stat.ATK, _random.randi_range(30, 50))
	s.set_stat(StatTypes.Stat.DEF, _random.randi_range(30, 50))
	return actor


func create_items():
	var combined_slots = EquipSlots.Slot.PRIMARY | EquipSlots.Slot.SECONDARY
	inventory.append(create_consumable_item("Health Potion", StatTypes.Stat.HP, 300))
	inventory.append(create_consumable_item("Bomb", StatTypes.Stat.HP, -150))
	inventory.append(create_equippable_item("Sword", StatTypes.Stat.ATK, 10, EquipSlots.Slot.PRIMARY))
	inventory.append(create_equippable_item("Broad Sword", StatTypes.Stat.ATK, 15, combined_slots))
	inventory.append(create_equippable_item("Shield", StatTypes.Stat.DEF, 10, EquipSlots.Slot.SECONDARY))


func create_combatants():
	combatants.append(create_hero())
	combatants.append(create_actor("Monster"))
	

func simulate_battle():
	while victory_check() == false:
		log_combatants()
		hero_turn()
		enemy_turn()
		var time_in_seconds = 1
		await get_tree().create_timer(time_in_seconds).timeout
	
	log_combatants()
	print("Battle Completed")


func hero_turn():
	var rnd: int = _random.randi_range(0, 1)
	match(rnd):
		0:
			attack(combatants[0], combatants[1])
		_:
			use_inventory()


func enemy_turn():
	attack(combatants[1], combatants[0])


func attack(attacker: Node, defender: Node):
	var s1: Stats
	var s2: Stats
	for child in attacker.get_children():
		if child is Stats:
			s1 = child
	
	for child in defender.get_children():
		if child is Stats:
			s2 = child
	
	var damage: int = floori((s1.get_stat(StatTypes.Stat.ATK) * 4 - s2.get_stat(StatTypes.Stat.DEF) * 2) * _random.randf_range(0.9, 1.1))
	s2.set_stat(StatTypes.Stat.HP, s2.get_stat(StatTypes.Stat.HP) - damage)
	var message: String = "{0} hits {1} for {2}".format([attacker.name, defender.name, damage])
	print(message)


func use_inventory():
	if inventory.size() == 0:
		print("No Inventory")
		return
	
	var rnd: int = _random.randi_range(0, inventory.size() - 1)
	var item: Node = inventory[rnd]
	for child in item.get_children():
		if child is Consumable:
			consume_item(item)
		if child is Equippable:
			equip_item(item)


func consume_item(item: Node):
	inventory.erase(item)
	var smf: StatModifierFeature
	var consumable: Consumable
	
	for child in item.get_children():
		if child is StatModifierFeature:
			smf = child
		elif child is Consumable:
			consumable = child
	
	if smf.amount > 0:
		consumable.consume(combatants[0])
		print("Ah... a potion!")
	
	else:
		consumable.consume(combatants[1])
		print("Take this!")

func equip_item(item: Node):
	print("Perhaps this will help...")
	var to_equip: Equippable
	for child in item.get_children():
		if child is Equippable:
			to_equip = child
	
	var equipment: Equipment
	for child in combatants[0].get_children():
		if child is Equipment:
			equipment = child
	
	equipment.equip(to_equip, to_equip.default_slots)
	

func victory_check():
	for combatant in combatants:
		for child in combatant.get_children():
			if child is Stats:
				if child.get_stat(StatTypes.Stat.HP) <= 0:
					return true
	
	return false


func log_combatants():
	print("===========")
	for combatant in combatants:
		log_to_console(combatant)
	print("===========")


func log_to_console(actor: Node):
	var s: Stats
	for child in actor.get_children():
		if child is Stats:
			s = child
	
	var message: String = "Name: {0} HP: {1}/{2} ATK:{3} DEF:{4}".format([actor.name, s.get_stat(StatTypes.Stat.HP), s.get_stat(StatTypes.Stat.MHP), s.get_stat(StatTypes.Stat.ATK), s.get_stat(StatTypes.Stat.DEF)])
	print(message)
