extends ImplantEffect
class_name AddShieldStrengthEffect

##To subtract, insert a negative value
@export var amount: int

func apply(_context = null) -> void:
	add_to_player_stats(Stats.List.SHIELD_STRENGTH, amount, lesser, 0)
	Global.player_stats_bar.update()

func revert() -> void:
	if !is_permanent:
		add_to_player_stats(Stats.List.SHIELD_STRENGTH, -amount, lesser, 0)
		Global.player_stats_bar.update()
