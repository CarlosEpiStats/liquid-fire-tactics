extends Node

@export var child_panel: LayoutAnchor
@export var text_label: Label
@export var animated: bool

func _ready() -> void:
	for i in 9:
		for j in 9:
			text_label.text = str("child_anchor: ", i, " parent_anchor: ", j)
			
			if animated:
				await child_panel.move_to_anchor_position(i, j, Vector2.ZERO, 0.5)
				await get_tree().create_timer(0.5).timeout
			
			else:
				child_panel.snap_to_anchor_position(i, j, Vector2.ZERO)
				await get_tree().create_timer(1).timeout
