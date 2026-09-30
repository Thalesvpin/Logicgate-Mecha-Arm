extends ImplantCondition
class_name ShieldCountCondition

@export var amount: int = 0

func is_met(context = null) -> bool:
	return Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD_COUNT] == amount
