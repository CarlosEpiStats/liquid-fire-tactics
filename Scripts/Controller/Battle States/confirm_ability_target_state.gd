extends BattleState

@export var perform_ability_state: State
@export var ability_target_state: State

var tiles
var ability_area: AbilityArea
var index: int = 0

func enter():
	super()
	var filtered = turn.ability.get_children().filter(func(node): return node is AbilityArea)
	ability_area = filtered[0]
	tiles = ability_area.get_tiles_in_area(board, pos)
	board.select_tiles(tiles)
	find_targets()
	refresh_primary_stat_panel(turn.actor.tile.pos)
	if turn.targets.size() > 0:
		await hit_success_indicator.show_panel()
		set_target(0)


func exit():
	super()
	board.deselect_tiles(tiles)
	await stat_panel_controller.hide_primary()
	await stat_panel_controller.hide_secondary()
	await hit_success_indicator.hide_panel()


func on_move(e: Vector2i):
	if e.x > 0 or e.y < 0:
		set_target(index + 1)
	
	else:
		set_target(index - 1)


func on_fire(e: int):
	if e == 0:
		if turn.targets.size() > 0:
			_owner.state_machine.change_state(perform_ability_state)
		
	else:
		_owner.state_machine.change_state(ability_target_state)


# Get a list of all the AbilityEffectTarget objects that are attached to an ability
# and determines which tiles have valid targets on them
func find_targets():
	turn.targets = []
	var children: Array[Node] = turn.ability.get_children()
	var targeters: Array[AbilityEffectTarget]
	targeters.assign(children.filter(func(node): return node is AbilityEffectTarget))
	
	for tile in tiles:
		if is_target(tile, targeters):
			turn.targets.append(tile)


func is_target(tile: Tile, list: Array[AbilityEffectTarget]):
	for item in list:
		if item.is_target(tile):
			return true
	
	return false


func set_target(target: int):
	index = target
	if index < 0:
		index = turn.targets.size()
	
	if index >= turn.targets.size():
		index = 0
	
	if turn.targets.size() > 0:
		refresh_secondary_stat_panel(turn.targets[index].pos)
		update_hit_success_indicator()


func update_hit_success_indicator():
	var chance: int = calculate_hit_rate()
	var amount: int = estimate_damage()
	hit_success_indicator.set_stats(chance, amount)

func calculate_hit_rate():
	var target = turn.targets[index].content
	var children: Array[Node] = turn.ability.find_children("*", "HitRate", false)
	if children:
		var hr: HitRate = children[0]
		return hr.calculate(turn.actor, target)
	
	print("Couldn't find Hit Rate")
	return 0

func estimate_damage() -> int:
	return 50


func zoom(scroll: int):
	_owner.camera_controller.zoom(scroll)


func orbit(direction: Vector2):
	_owner.camera_controller.orbit(direction)
