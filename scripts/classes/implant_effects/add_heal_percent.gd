extends ImplantEffect
class_name AddHealPercentEffect

@export var amount: float
#@export var who: Variant
var percent: float

func apply(_context = null) -> void:
	add_to_extra_stats(Stats.List.BASE_HEAL, amount, range, 0, 100)

func revert() -> void:
	add_to_extra_stats(Stats.List.MAX_HEALTH, -amount, range, 0, 100)
