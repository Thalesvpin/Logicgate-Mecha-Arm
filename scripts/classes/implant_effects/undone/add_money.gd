extends ModifierEffect
class_name AddMoneyEffect

##To subtract, insert a negative value
@export var amount: int

func apply(context = null) -> void:
	var result = add_to_player_stats(Stats.List.CURRENT_MONEY, amount)
	EventBus.stat_changed.emit(Stats.List.CURRENT_MONEY, result)

func revert() -> void:
	pass
