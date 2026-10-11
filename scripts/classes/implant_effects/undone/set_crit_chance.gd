extends ImplantEffect
class_name SetCriticChanceEffect

##To subtract, insert a negative value
@export_range(0, 100) var amount: float = 0.0
@export var who: Variant
var old_value: float = 0

func apply(_context = null) -> void:
	old_value = get_player_stat(Stats.List.CRITIC_CHANCE)
	set_player_stat(Stats.List.CRITIC_CHANCE, amount)
	EventBus.stat_changed.emit(Stats.List.CRITIC_CHANCE, amount)

func revert() -> void:
	if !is_permanent:
		set_player_stat(Stats.List.CRITIC_CHANCE, old_value)
		EventBus.stat_changed.emit(Stats.List.CRITIC_CHANCE, old_value)
