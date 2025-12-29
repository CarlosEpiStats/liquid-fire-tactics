extends BattleState

@export var select_unit_state: State
var data: ConversationData

func _ready():
	super()
	data = load("res://Data/Conversations/intro_scene.tres")


func add_listeners():
	super()
	_owner.conversation_controller.completed_event.connect(on_completed_conversation)


func remove_listeners():
	super()
	_owner.conversation_controller.completed_event.disconnect(on_completed_conversation)


func enter():
	super()
	_owner.conversation_controller.show_conversation(data)


func on_fire(e: int):
	super(e)
	_owner.conversation_controller.next()


func on_completed_conversation():
	_owner.state_machine.change_state(select_unit_state)
