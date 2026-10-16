extends Node

var turn_sequence: Array = ['player']
var turn_idx: int = 0

func _ready() -> void:
	Global.turn_manager = self
	EventBus.turn_ended.connect(handle_next_turn)

func handle_next_turn(who) -> void:
	turn_idx = turn_sequence.find(who)
	if turn_idx == turn_sequence.size()-1:
		turn_idx = 0
	else:
		turn_idx += 1
	EventBus.turn_started.emit(turn_sequence[turn_idx])

func add_to_sequence(alguma_coisa) -> void:
	if turn_sequence.size() < 4:
		turn_sequence.append(alguma_coisa)
