class_name FullTypeHitRate
extends HitRate

func calculate(attacker: Unit, target: Unit):
	if automatic_miss(attacker, target):
		return final(100)
	
	return final(0)
	
