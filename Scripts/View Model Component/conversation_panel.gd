class_name ConversationPanel
extends LayoutAnchor

signal finished

@export var message: Label
@export var speaker: TextureRect
@export var arrow: Node
@export var anchor_list: Array[PanelAnchor] = []

var _parent: ConversationController

func _ready():
	_parent = get_node("../")


func get_anchor(anchor_name: String):
	for anchor in self.anchor_list:
		if anchor.anchor_name == anchor_name:
			return anchor
		
	return null


func display(speaker_data: SpeakerData):
	speaker.texture = speaker_data.speaker
	speaker.size = speaker.texture.get_size()
	
	# Resets the anchor point after resizing
	speaker.anchors_preset = speaker.anchors_preset
	
	for i in speaker_data.messages.size():
		message.text = tr(speaker_data.messages[i])
		arrow.visible = i + 1 < speaker_data.messages.size()
		await _parent.resumed
	
	finished.emit()
