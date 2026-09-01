extends ModifierEffect
class_name AddMaxHealthEffect

##To subtract, insert a nagative value
@export var amount: int = 0

func apply() -> void:
	var result = add_to_player_stats(Stats.List.MAX_HEALTH, amount, lesser, 0)
	#var result = Global.run_stats.player_stats[Stats.List.MAX_HEALTH] + amount
	#if result < 0:
		#result = 1
	#Global.run_stats.player_stats[Stats.List.MAX_HEALTH] = result
	EventBus.stat_changed.emit(Stats.List.MAX_HEALTH , result)

func revert() -> void:
	if !is_permanent:
		var result = add_to_player_stats(Stats.List.MAX_SHIELD, -amount, lesser, 1)
		#var result = Global.run_stats.player_stats[Stats.List.MAX_HEALTH] - amount
		#Global.run_stats.player_stats[Stats.List.MAX_HEALTH] = result
		EventBus.stat_changed.emit(Stats.List.MAX_HEALTH , result)
