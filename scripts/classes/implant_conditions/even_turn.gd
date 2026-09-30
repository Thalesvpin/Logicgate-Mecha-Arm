extends ImplantCondition
class_name EvenTurnCondition

func is_met(context = null) -> bool:
	return !(Global.run_stats.current_turn % 2)
