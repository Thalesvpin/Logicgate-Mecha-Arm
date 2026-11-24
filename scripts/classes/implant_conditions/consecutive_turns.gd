extends ImplantCondition
class_name ConsecutiveTurnsCondition

##Progressive changes the way the condition works.[br]
##If false, the condition will be met every [amount] consecutive turns.[br]
##If true, the condition will be met every consecutive turn after the [amount]'st
@export var progressive: bool = false
@export_range(2, 99999, 1) var amount: int = 2

var count: int = 0
var last_turn: int = 0
var damaged_this_turn: bool = false
var hooked: bool = false

func hook() -> void:
	if hooked:
		return
	hooked = true
	EventBus.battle_ended.connect(
		func():
			count = 0
			last_turn = 0
			damaged_this_turn = false
			abort.emit()
	)
	EventBus.turn_ended.connect(
		func(who):
			if who != "player":
				return
			if not damaged_this_turn and count > 0:
				count = 0
				last_turn = 0
				abort.emit()
			damaged_this_turn = false
	)

func is_met(_context = null) -> bool:
	hook()
	var turn = Global.run_stats.current_turn
	if last_turn == turn:
		return false
	damaged_this_turn = true
	if last_turn == turn - 1:
		count += 1
		last_turn = turn
		if count >= amount:
			if !progressive:
				count = 0
			return true
	else:
		count = 1
		last_turn = turn
	return false
