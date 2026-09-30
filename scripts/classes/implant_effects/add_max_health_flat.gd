extends ModifierEffect
class_name AddMaxHealthFlatEffect

##To subtract, insert a nagative value
@export var amount: int = 0
#@export var who: Variant

func apply(context = null) -> void:
	var result = add_to_player_stats(Stats.List.MAX_HEALTH, amount, lesser, 1)
	EventBus.stat_changed.emit(Stats.List.MAX_HEALTH , result)

func revert() -> void:
	if !is_permanent:
		var result = add_to_player_stats(Stats.List.MAX_SHIELD, -amount, lesser, 1)
		EventBus.stat_changed.emit(Stats.List.MAX_HEALTH , result)
