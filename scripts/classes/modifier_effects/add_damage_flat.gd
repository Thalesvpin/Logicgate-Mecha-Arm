extends ModifierEffect
class_name AddDamageFlatEffect

##To subtract, insert a negative value
@export var amount: float
@export var who: Variant

func apply() -> void:
	var result = add_to_player_stats(Stats.List.BASE_ATTACK_DAMAGE, amount, lesser, 0)
	EventBus.stat_changed.emit(Stats.List.BASE_ATTACK_DAMAGE, result)

func revert() -> void:
	if !is_permanent:
		var result = add_to_player_stats(Stats.List.BASE_ATTACK_DAMAGE, -amount, lesser, 0)
		EventBus.stat_changed.emit(Stats.List.BASE_ATTACK_DAMAGE, result)
		
