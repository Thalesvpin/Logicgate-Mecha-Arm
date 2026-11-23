extends ImplantEffect
class_name AddDamagePercentEffect

##To subtract, insert a negative value
@export_custom(PROPERTY_HINT_NONE, 'suffix:%') var amount: float
#@export var who: Variant
var percent: float
var total_added: int = 0

func apply(_context = null) -> void:
	print('add_dmg_percent')
	#percent = get_player_stat(Stats.List.BASE_ATTACK_DAMAGE) * (amount/100)
	add_to_extra_stats(Stats.List.BASE_ATTACK_DAMAGE_MULT, amount, lesser, 0)
	total_added += amount

func revert() -> void:
	if !is_permanent:
		add_to_extra_stats(Stats.List.BASE_ATTACK_DAMAGE_MULT, -total_added, lesser, 0)
	
