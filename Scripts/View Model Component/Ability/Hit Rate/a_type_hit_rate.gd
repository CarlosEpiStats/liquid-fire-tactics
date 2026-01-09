class_name ATypeHitRate
extends HitRate

func calculate(attacker: Unit, target: Unit):
	if automatic_hit(attacker, target):
		return final(0)
	
	if automatic_miss(attacker, target):
		return final(100)
	
	var evade: int = get_evade(target)
	evade = adjust_for_relative_facing(attacker, target, evade)
	evade = adjust_for_status_effect(attacker, target, evade)
	evade = clamp(evade, 5, 95)
	return final(evade)

func get_evade(target: Unit):
	var s: Stats = target.get_node("Stats")
	return clamp(s.get_stat(StatTypes.Stat.EVD), 0, 100)


func adjust_for_relative_facing(attacker: Unit, target: Unit, rate: int):
	match Directions.get_facing(attacker, target):
		Directions.Facings.FRONT:
			return rate
		
		Directions.Facings.SIDE:
			return rate/2
		
		_:
			return rate/4
	
	
