extends Node
class_name BattleController

@export var board: BoardCreator
@export var input_controller: InputController
@export var camera_controller: CameraController
@export var state_machine: StateMachine
@export var start_state: State
@export var hero_prefab: PackedScene
@export var conversation_controller: ConversationController
@export var ability_menu_panel_controller: AbilityMenuPanelController
@export var stat_panel_controller: StatPanelController
@export var turn_order_controller: TurnOrderController

var turn := Turn.new()
var units: Array[Unit] = []
var current_tile: Tile: 
	get: return board.get_tile(board.pos)


func _ready():
	state_machine.change_state(start_state)
