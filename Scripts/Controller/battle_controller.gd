extends Node
class_name BattleController

@export var board: BoardCreator
@export var inputController: InputController
@export var cameraController: CameraController
@export var stateMachine: StateMachine
@export var startState: State
@export var heroPrefab: PackedScene
@export var conversation_controller: ConversationController
var currentUnit: Unit
var currentTile: Tile: 
	get: return board.GetTile(board.pos)

func _ready():
	stateMachine.ChangeState(startState)
