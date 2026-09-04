extends ModifierEffect
class_name AddCriticChanceFlat

##To subtract, insert a negative value
@export var amount: float = 0.0

func apply() -> void:
	var result = add_to_player_stats(Stats.List.CRITIC_CHANCE, amount, lesser, 0)
	#var result = Global.run_stats.player_stats[Stats.List.CRITIC_CHANCE] + amount
	#if result < 0:
		#result = 0
	#Global.run_stats.player_stats[Stats.List.CRITIC_CHANCE] = result
	EventBus.stat_changed.emit(Stats.List.CRITIC_CHANCE, result)

func revert() -> void:
	if !is_permanent:
		var result = add_to_player_stats(Stats.List.CRITIC_CHANCE, -amount, lesser, 0)
		#var result = Global.run_stats.crit_chance - amount
		#if result < 0:
			#result = 0
		#Global.run_stats.player_stats[Stats.List.CRITIC_CHANCE] = result
		EventBus.stat_changed.emit(Stats.List.CRITIC_CHANCE, result)
