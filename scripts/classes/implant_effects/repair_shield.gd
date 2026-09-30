extends ModifierEffect
class_name RepairShieldEffect

@export var amount: int = 0:
	set(value):
		amount = max(value, 0)

func apply(context = null) -> void:
	add_to_player_stats(Stats.List.CURRENT_SHIELD, amount, greater, Global.run_stats.player_stats[Stats.List.MAX_SHIELD])
	Global.player_stats_bar.repair_shield(amount)
	
	#EventBus.repaired_shield.emit(amount)

func revert() -> void:
	pass
