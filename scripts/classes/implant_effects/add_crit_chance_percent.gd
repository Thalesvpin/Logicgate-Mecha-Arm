extends ImplantEffect
class_name AddCritChancePercent

##To subtract, insert a negative value
@export var amount: float
@export var who: Variant
var percent: float

func apply(_context = null) -> void:
	percent = get_player_stat(Stats.List.CRITIC_CHANCE) * (amount/100)
	var result = add_to_player_stats(Stats.List.CRITIC_CHANCE, percent, lesser, 0)
	EventBus.stat_changed.emit(Stats.List.CRITIC_CHANCE, result)

func revert() -> void:
	if !is_permanent:
		var result = add_to_player_stats(Stats.List.CRITIC_CHANCE, -percent, lesser, 0)
		EventBus.stat_changed.emit(Stats.List.CRITIC_CHANCE, result)
