extends ImplantCondition
class_name ActiveShieldCountCondition

@export var compared_value: int
@export var operator: Operators.Type

func is_met(context = null) -> bool:
	var result
	match operator:
		Operators.Type.EQUAL:
			result = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD_COUNT] == compared_value
		Operators.Type.LESSER:
			result = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD_COUNT] > compared_value
		Operators.Type.GREATER:
			result = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD_COUNT] < compared_value
		Operators.Type.LESSER_EQUAL:
			result = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD_COUNT] >= compared_value
		Operators.Type.GREATER_EQUAL:
			result = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD_COUNT] <= compared_value
	return result
