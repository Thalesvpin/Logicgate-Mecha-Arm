extends ImplantEffect
class_name AddMaxShieldCountEffect

##To subtract, insert a negative value
@export var amount: int

func apply(_context = null) -> void:
	add_to_player_stats(Stats.List.MAX_SHIELD_COUNT, amount, lesser, 0)

func revert() -> void:
	if !is_permanent:
		add_to_player_stats(Stats.List.MAX_SHIELD_COUNT, -amount, lesser, 0)
