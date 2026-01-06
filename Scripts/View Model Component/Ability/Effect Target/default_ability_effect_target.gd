extends AbilityEffectTarget

# true if the target has HP greater than 0
func is_target(tile: Tile):
	if tile == null or tile.content == null:
		return false
	
	var s: Stats = tile.content.get_node("Stats")
	return s != null and s.get_stat(StatTypes.Stat.HP) > 0
