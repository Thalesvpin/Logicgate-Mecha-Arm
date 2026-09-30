extends ModifierEffect
class_name AddMaxTokensEffect

##To subtract, insert a nagative value
@export var amount: int = 0

func apply(context = null) -> void:
	var result = add_to_player_stats(Stats.List.MAX_TOKENS_AMOUNT, amount, lesser, 1)
	EventBus.stat_changed.emit(Stats.List.MAX_TOKENS_AMOUNT , result)

func revert() -> void:
	if !is_permanent:
		var result = add_to_player_stats(Stats.List.MAX_TOKENS_AMOUNT, -amount, lesser, 1)
		EventBus.stat_changed.emit(Stats.List.MAX_TOKENS_AMOUNT , result)
