extends Node

var heroes: Array[Node] = []
var _random = RandomNumberGenerator.new()

func _ready() -> void:
	_random.randomize()
	verify_level_to_experience_calculations()
	verify_shared_experience_distribution()


func _exit_tree() -> void:
	for actor in heroes:
		var stats: Stats = actor.get_node("Stats")
		stats.did_change_notification(StatTypes.Stat.LVL).disconnect(on_level_change)
		stats.will_change_notification(StatTypes.Stat.EXP).disconnect(on_experience_exception)


func verify_level_to_experience_calculations():
	for i in range(1, 100):
		var exp_lvl: int = Rank.experience_for_level(i)
		var lvl_exp: int = Rank.level_for_experience(exp_lvl)
		
		if lvl_exp != i:
			print("Mismatch on level:{0} with exp:{1} returned:{2}".format([i, exp_lvl, lvl_exp]))
		
		else:
			print("Level:{0} = Exp:{1}".format([lvl_exp, exp_lvl]))


func verify_shared_experience_distribution():
	var party: Array[String] = ["Ramza", "Bowie", "Marth", "Ike", "Delita", "Max"]
	
	for hero in party:
		var actor: Node = Node.new()
		actor.name = hero
		self.add_child(actor)
		
		var stats: Stats = Stats.new()
		stats.name = "Stats"
		actor.add_child(stats)
		stats.did_change_notification(StatTypes.Stat.LVL).connect(on_level_change)
		stats.will_change_notification(StatTypes.Stat.EXP).connect(on_experience_exception)
		
		var rank: Rank = Rank.new()
		rank.name = "Rank"
		actor.add_child(rank)
		rank.init(_random.randi_range(1, 4))
		
		heroes.append(actor)
		
	print("=== Before Adding Experience =====")
	log_party(heroes)
	
	print("==================================")
	ExperienceManager.award_experience(1000, heroes)
	
	print("==== After Adding Experience ====")
	log_party(heroes)
	

func log_party(party: Array[Node]):
	for actor in party:
		var rank = actor.get_node("Rank")
		print("Name:{0} Level:{1} Exp:{2}".format([actor.name, rank.lvl, rank.xp]))


func on_level_change(sender: Stats, old_value: int):
	var actor: Node = sender.get_parent()
	print(actor.name + " leveled up!")


func on_experience_exception(sender: Stats, vce: ValueChangeException):
	var actor: Node = sender.get_parent()
	var roll: int = _random.randi_range(0, 4)
	match roll:
		0:
			vce.flip_toggle()
			print("{0} would have received {1} experience, but we stopped it".format([actor.name, vce.delta]))
		
		1:
			vce.add_modifiers(AddValueModifier.new(0, 100))
			print("{0} would have received {1} experience, but we added 1000".format([actor.name, vce.delta]))
		
		2:
			vce.add_modifiers(MultDeltaModifier.new(0, 2))
			print("{0} would have received {1} experience, but we multiplied by 2".format([actor.name, vce.delta]))
		
		_:
			print("{0} will receive {1} experience".format([actor.name, vce.delta]))
