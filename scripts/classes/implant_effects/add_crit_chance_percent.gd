extends ImplantEffect
class_name AddCritChancePercent

##To subtract, insert a negative value
@export var amount: float
@export var who: Variant

func apply(_context = null) -> void:
	add_to_player_stats(Stats.List.CRITIC_CHANCE, amount, lesser, 0)

func revert() -> void:
	if !is_permanent:
		add_to_player_stats(Stats.List.CRITIC_CHANCE, -amount, lesser, 0)
