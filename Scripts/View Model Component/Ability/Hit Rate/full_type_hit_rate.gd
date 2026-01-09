class_name FullTypeHitRate
extends HitRate

func calculate(target: Tile):
	var defender = target.content
	if automatic_miss(defender):
		return final(100)
	
	return final(0)
	
