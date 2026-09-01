extends ModifierEffect
class_name RepairShield

@export var amount: int = 0:
	set(value):
		amount = max(value, 0)

func apply() -> void:
	var result = add_to_player_stats(Stats.List.CURRENT_SHIELD, amount, greater, Global.run_stats.player_stats[Stats.List.MAX_SHIELD])
	#var result = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD] + amount
	#if result > Global.run_stats.player_stats[Stats.List.MAX_SHIELD]:
		#result = Global.run_stats.player_stats[Stats.List.MAX_SHIELD]
	#Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD] = result
	EventBus.repaired_shield.emit(result)

func revert() -> void:
	pass
