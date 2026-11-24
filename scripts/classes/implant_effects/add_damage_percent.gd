extends ImplantEffect
class_name AddDamagePercentEffect

##To subtract, insert a negative value
@export_custom(PROPERTY_HINT_NONE, 'suffix:%') var amount: float
#@export var who: Variant
var percent: float
var total_added: float = 0.0

func apply(_context = null) -> void:
	print('add_dmg_percent: ', amount/100)
	#percent = get_player_stat(Stats.List.BASE_ATTACK_DAMAGE) * (amount/100)
	add_to_extra_stats(Stats.List.BASE_ATTACK_DAMAGE_MULT, amount/100, lesser, 0)
	total_added += amount/100

func revert() -> void:
	if !is_permanent and total_added != 0.0:
		add_to_extra_stats(Stats.List.BASE_ATTACK_DAMAGE_MULT, -total_added, lesser, 0)
		total_added = 0.0
