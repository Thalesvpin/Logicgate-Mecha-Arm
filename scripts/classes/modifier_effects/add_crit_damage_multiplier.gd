extends ModifierEffect
class_name AddCritDamageMult

##To subtract, insert a negative value
@export var amount: int

func apply() -> void:
	var result = add_to_player_stats(Stats.List.CRITIC_MULTIPLIER, amount, lesser, 0)
	EventBus.stat_changed.emit(Stats.List.CRITIC_MULTIPLIER, result)

func revert() -> void:
	if !is_permanent:
		var result = add_to_player_stats(Stats.List.CRITIC_MULTIPLIER, -amount, lesser, 0)
		EventBus.stat_changed.emit(Stats.List.CRITIC_MULTIPLIER, result)
