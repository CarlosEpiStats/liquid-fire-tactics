class_name StatPanel
extends LayoutAnchor

@export var ally_background: Texture2D
@export var enemy_background: Texture2D
@export var background: NinePatchRect
@export var avatar: TextureRect
@export var hp_label: Label
@export var name_label: Label
@export var mp_label: Label
@export var lvl_label: Label
@export var anchor_list: Array[PanelAnchor] = []

func set_position(anchor_name: String, animated: bool):
	var anchor = get_anchor(anchor_name)
	await to_anchor_position(anchor, animated)
	

func get_anchor(anchor_name: String):
	for anchor in self.anchor_list:
		if anchor.anchor_name == anchor_name:
			return anchor
		
	return null


func display(obj: Node):
	# Temp until later lesson when we add a component to determine unit alliances
	background.texture = [ally_background, enemy_background].pick_random()
	#avatar.texture = need a component which provides this data
	name_label.text = obj.name
	var stats: Stats = obj.get_node("Stats")
	if stats:
		hp_label.text = "HP {0} / {1}".format([stats.get_stat(StatTypes.Stat.HP), stats.get_stat(StatTypes.Stat.MHP)])
		mp_label.text = "MP {0} / {1}".format([stats.get_stat(StatTypes.Stat.MP), stats.get_stat(StatTypes.Stat.MMP)])
		lvl_label.text = "LV.{0}".format([stats.get_stat(StatTypes.Stat.LVL)])
		
