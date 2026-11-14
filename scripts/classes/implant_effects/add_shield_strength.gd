extends ImplantEffect
class_name AddShieldStrengthEffect

##To subtract, insert a negative value
@export var amount: int

func apply(_context = null) -> void:
	var result = add_to_player_stats(Stats.List.SHIELD_STRENGTH, amount, lesser, 0)
	#EventBus.stat_changed.emit(Stats.List.SHIELD_STRENGTH , result)

func revert() -> void:
	if !is_permanent:
		var result = add_to_player_stats(Stats.List.SHIELD_STRENGTH, -amount, lesser, 0)
		#EventBus.stat_changed.emit(Stats.List.SHIELD_STRENGTH , result)
