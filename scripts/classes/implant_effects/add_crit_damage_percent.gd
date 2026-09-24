extends ModifierEffect
class_name AddCritDamagePercent

##To subtract, insert a negative value
@export var amount: float
#@export var who: Variant
var percent: float

func apply() -> void:
	percent = get_player_stat(Stats.List.CRITIC_MULTIPLIER) * (amount/100)
	var result = add_to_player_stats(Stats.List.CRITIC_MULTIPLIER, percent, lesser, 0)
	EventBus.stat_changed.emit(Stats.List.CRITIC_MULTIPLIER, result)

func revert() -> void:
	if !is_permanent:
		var result = add_to_player_stats(Stats.List.CRITIC_MULTIPLIER, -percent, lesser, 0)
		EventBus.stat_changed.emit(Stats.List.CRITIC_MULTIPLIER, result)
