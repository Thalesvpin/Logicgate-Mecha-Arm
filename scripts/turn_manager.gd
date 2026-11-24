extends Node

var turn_sequence: Array = ['player']
var turn_idx: int = 0
var turn_token: int = 0
var is_shop_open: bool = false
var extra_player_turns: int = 0
var restart_player_after_block: bool = false

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
	EventBus.turn_started.emit(0)

func handle_next_turn(who) -> void:
	turn_idx = turn_sequence.find(who)
	if who is String && who == 'player' && extra_player_turns > 0:
		extra_player_turns -= 1
		turn_idx = 0
		restart_player_after_block = true
		return
	if turn_idx == turn_sequence.size() - 1:
		turn_idx = 0
	else:
		turn_idx += 1
	print('handle_next_turn: ', turn_idx)
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
	if turn_sequence[turn_idx] == 'player':
		extra_player_turns = 1
		return
	turn_idx = 0
	turn_token += 1
	EventBus.turn_started.emit('player')

func emit_player_turn() -> void:
	EventBus.turn_started.emit('player')
