extends ImplantEffect
class_name AddMitigationPercentEffect

##To subtract, insert a nagative value
@export_custom(PROPERTY_HINT_NONE, 'suffix:%') var amount: float = 0.0

func apply(_context = null) -> void:
	var result = add_to_player_stats(Stats.List.MITIGATION_PERCENT, amount, range, 0, 1)
	EventBus.stat_changed.emit(Stats.List.MAX_TOKENS_AMOUNT , result)

func revert() -> void:
	if !is_permanent:
		var result = add_to_player_stats(Stats.List.MITIGATION_PERCENT, -amount, range, 0, 1)
		EventBus.stat_changed.emit(Stats.List.MAX_TOKENS_AMOUNT , result)
