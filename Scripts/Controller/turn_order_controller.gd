class_name TurnOrderController
extends Node

const TURN_ACTIVATION: int = 500
const TURN_COST: int = 500
const MOVE_COST: int = 300
const ACTION_COST: int = 200

signal round_began()
signal turn_checked(exc: BaseException)
signal turn_completed(unit: Unit)
signal round_ended()
signal round_resumed()
