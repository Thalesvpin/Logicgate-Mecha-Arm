extends ImplantCondition
class_name ConsecutiveTurnsCondition

##Progressive changes the way the condition works.[br]
##If false, the condition will be met every [amount] consecutive turns.[br]
##If true, the condition will be met every consecutive turn after the [amount]'st
@export var progressive: bool = false
@export_range(2, 99999, 1) var amount: int = 2

var count: int = 0
var last_turn: int = 0

func is_met(context = null) -> bool:
	var turn = Global.run_stats.current_turn
	if last_turn == turn:
		return false
	if last_turn == turn-1:
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
