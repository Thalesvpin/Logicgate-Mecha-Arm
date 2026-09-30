extends ModifierEffect
class_name AddCriticChanceFlat

##To subtract, insert a negative value
@export var amount: float = 0.0

func apply(context = null) -> void:
	var result = add_to_player_stats(Stats.List.CRITIC_CHANCE, amount, lesser, 0)
	EventBus.stat_changed.emit(Stats.List.CRITIC_CHANCE, result)

func revert() -> void:
	if !is_permanent:
		var result = add_to_player_stats(Stats.List.CRITIC_CHANCE, -amount, lesser, 0)
		EventBus.stat_changed.emit(Stats.List.CRITIC_CHANCE, result)
