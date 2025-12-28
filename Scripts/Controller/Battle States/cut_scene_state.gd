extends BattleState

@export var select_unit_state: State
var data: ConversationData

func _ready():
	super()
	data = load("res://Data/Conversations/intro_scene.tres")


func AddListeners():
	super()
	_owner.conversation_controller.completed_event.connect(on_completed_conversation)


func RemoveListeners():
	super()
	_owner.conversation_controller.completed_event.disconnect(on_completed_conversation)


func Enter():
	super()
	_owner.conversation_controller.show_conversation(data)


func OnFire(e: int):
	super(e)
	_owner.conversation_controller.next()


func on_completed_conversation():
	_owner.stateMachine.ChangeState(select_unit_state)
