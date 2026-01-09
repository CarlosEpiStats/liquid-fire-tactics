class_name STypeHitRate
extends HitRate

func calculate(attacker: Unit, target: Unit):
	if automatic_miss(attacker, target):
		return final(100)
	
	if automatic_hit(attacker, target):
		return final(0)
	
	var res: int = get_resistance(target)
	res = adjust_for_status_effect(attacker, target, res)
	res = adjust_for_relative_facing(attacker, target, res)
	res = clamp(res, 0, 100)
	return final(res)

func get_resistance(target: Unit):
	var s: Stats = target.get_node("Stats")
	return clamp(s.get_stat(StatTypes.Stat.RES), 0, 100)


func adjust_for_relative_facing(attacker: Unit, target: Unit, rate: int):
	match Directions.get_facing(attacker, target):
		Directions.Facings.FRONT:
			return rate
		
		Directions.Facings.SIDE:
			return rate - 10
		
		_:
			return rate - 20
	
	
