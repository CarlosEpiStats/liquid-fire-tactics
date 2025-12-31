class_name ExperienceManager
extends Node

const MIN_LEVEL_BONUS: float = 1.5
const MAX_LEVEL_BONUS: float = 0.5

static func award_experience(amount: int, party: Array[Node]):
	# Grab a list of all the rank components from our hero party
	var ranks: Array[Rank] = []
	for unit in party:
		var r: Rank = unit.get_node("Rank")
		if r != null:
			ranks.append(r)
	
	# Step 1: determine the range in actor level stats
	var min_rank: int = 999_999
	var max_rank: int = -999_999
	
	for rank in ranks:
		min_rank = min(rank.lvl, min_rank)
		max_rank = max(rank.lvl, max_rank)
	
	# Step 2: weight the amount to award per actor based on their level
	var weights: Array[float] = []
	weights.resize(ranks.size())
	var summed_weights: float = 0
	
	for i in ranks.size():
		var percent: float = (float)(ranks[i].lvl - min_rank + 1) / (float)(max_rank - min_rank + 1)
		weights[i] = lerp(MIN_LEVEL_BONUS, MAX_LEVEL_BONUS, percent)
		summed_weights += weights[i]
	
	# Step 3: hand out the weighted award
	for i in ranks.size():
		var sub_amount: int = floori((weights[i] / summed_weights) * amount)
		ranks[i].xp += sub_amount
