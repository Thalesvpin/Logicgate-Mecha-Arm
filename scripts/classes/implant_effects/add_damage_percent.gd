extends ImplantEffect
class_name AddDamagePercentEffect

##To subtract, insert a negative value
@export_custom(PROPERTY_HINT_NONE, 'suffix:%') var amount: float
#@export var who: Variant
var percent: float

func apply(_context = null) -> void:
	percent = get_player_stat(Stats.List.BASE_ATTACK_DAMAGE) * (amount/100)
	var result = add_to_extra_stats(Stats.List.BASE_ATTACK_DAMAGE, percent, lesser, 0)
	EventBus.stat_changed.emit(Stats.List.BASE_ATTACK_DAMAGE, result)

func revert() -> void:
	if !is_permanent:
		var result = add_to_player_stats(Stats.List.BASE_ATTACK_DAMAGE, -percent, lesser, 0)
		EventBus.stat_changed.emit(Stats.List.BASE_ATTACK_DAMAGE, result)
		
