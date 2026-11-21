extends Node

var turn_sequence: Array = ['player']
var turn_idx: int = 0
var is_shop_open: bool = false

func _ready() -> void:
	Global.turn_manager = self
	EventBus.turn_ended.connect(handle_next_turn)
	EventBus.battle_ended.connect(battle_ended)
	EventBus.battle_started.connect(battle_started)
	EventBus.enemy_defeated.connect(remove_from_sequence)

func battle_ended(result) -> void:
	is_shop_open = true

func battle_started(a = null) -> void:
	is_shop_open = false

func handle_next_turn(who) -> void:
	turn_idx = turn_sequence.find(who)
	if turn_idx == turn_sequence.size()-1:
		turn_idx = 0
	else:
		turn_idx += 1
	EventBus.turn_started.emit(turn_sequence[turn_idx])

func add_to_turn_sequence(who) -> void:
	if turn_sequence.size() < 4:
		turn_sequence.append(who)

func reset_turn_sequence() -> void:
	turn_sequence = ['player']
	turn_idx = 0

func remove_from_sequence(who) -> void:
	turn_sequence.erase(who)

func get_turn_index(who) -> int:
	return turn_sequence.find(who)

##It will never skip player's turn
func skip_turn(amount: int) -> void:
	turn_idx += amount
	if turn_idx > turn_sequence.size()-1:
		turn_idx = 0
	EventBus.turn_started.emit(turn_sequence[turn_idx])
