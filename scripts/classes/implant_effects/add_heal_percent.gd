extends ImplantEffect
class_name AddHealPercentEffect

@export var amount: float
#@export var who: Variant
var percent: float

func apply(_context = null) -> void:
	percent = get_player_stat(Stats.List.BASE_HEAL) * (amount/100)
	var result = add_to_extra_stats(Stats.List.BASE_HEAL, percent, range, 0, 100)
	EventBus.stat_changed.emit(Stats.List.BASE_HEAL, result)

func revert() -> void:
	var result = add_to_player_stats(Stats.List.BASE_HEAL, -percent, range, 0, 100)
	EventBus.stat_changed.emit(Stats.List.BASE_HEAL, result)
	
