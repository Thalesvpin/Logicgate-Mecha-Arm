extends ImplantEffect
class_name AddMaxHealthPercentEffect

##To subtract, insert a nagative value
@export_custom(PROPERTY_HINT_NONE, 'suffix:%') var amount: int = 0
#@export var who: Variant

func apply(_context = null) -> void:
	amount = Global.run_stats.player_stats[Stats.List.MAX_HEALTH] * amount/100
	var result = add_to_player_stats(Stats.List.MAX_HEALTH, amount, lesser, 1)
	EventBus.stat_changed.emit(Stats.List.MAX_HEALTH , result)

func revert() -> void:
	if !is_permanent:
		var result = add_to_player_stats(Stats.List.MAX_SHIELD, -amount, lesser, 1)
		EventBus.stat_changed.emit(Stats.List.MAX_HEALTH , result)
