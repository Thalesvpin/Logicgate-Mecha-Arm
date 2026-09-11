extends ModifierEffect
class_name HealEffect

@export var amount: int = 0:
	set(value):
		amount = max(value, 0)

func apply() -> void:
	add_to_player_stats(Stats.List.CURRENT_HEALTH, amount, greater, Global.run_stats.player_stats[Stats.List.MAX_HEALTH])	
	Global.player_stats_bar.heal(amount)
	
	#EventBus.healed.emit(amount)

func revert() -> void:
	pass
