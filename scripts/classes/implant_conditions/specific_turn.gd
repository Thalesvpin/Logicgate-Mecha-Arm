extends ImplantCondition
class_name SpecificTurnCondition

@export var turn: int = 0

func is_met(context = null) -> bool:
	return Global.run_stats.current_turn == turn
