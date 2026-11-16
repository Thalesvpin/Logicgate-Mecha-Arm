extends ImplantEffect
class_name AddMitigationPercentEffect

##To subtract, insert a nagative value
@export_custom(PROPERTY_HINT_NONE, 'suffix:%') var amount: float = 0.0

func apply(_context = null) -> void:
	var result = add_to_player_stats(Stats.List.MITIGATION_PERCENT, amount, range, 0, 70)

func revert() -> void:
	if !is_permanent:
		var result = add_to_player_stats(Stats.List.MITIGATION_PERCENT, -amount, range, 0, 70)
