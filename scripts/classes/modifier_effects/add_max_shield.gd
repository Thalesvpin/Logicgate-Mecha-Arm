extends ModifierEffect
class_name AddMaxShieldEffect

##To subtract, insert a negative value
@export var amount: int
var overflow: int = 0

func apply() -> void:
	var result = add_to_player_stats(Stats.List.MAX_SHIELD, amount, lesser, 0)
	#var result = Global.run_stats.player_stats[Stats.List.MAX_SHIELD] + amount
	#if result < 0:
		#overflow = abs(result)
		#result = 0
	#Global.run_stats.player_stats[Stats.List.MAX_SHIELD] = result
	EventBus.stat_changed.emit(Stats.List.MAX_SHIELD , result)

func revert() -> void:
	if !is_permanent:
		var result = add_to_player_stats(Stats.List.MAX_SHIELD, -amount, lesser, 0)
		#var result = Global.run_stats.player_stats[Stats.List.MAX_SHIELD] - amount
		#Global.run_stats.player_stats[Stats.List.MAX_SHIELD] = result
		EventBus.stat_changed.emit(Stats.List.MAX_SHIELD , result)
