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


func verify_level_to_experience_calculation():
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
		
		
