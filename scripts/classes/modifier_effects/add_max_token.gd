extends ModifierEffect

##To subtract, insert a nagative value
@export var amount: int = 0

func apply() -> void:
	var result = add_to_player_stats(Stats.List.MAX_TOKENS_AMOUNT, amount, lesser, 1)
	#var result = Global.run_stats.player_stats[Stats.List.MAX_TOKENS_AMOUNT] + amount
	#if result < 0:
		#result = 0
	#Global.run_stats.player_stats[Stats.List.MAX_TOKENS_AMOUNT] = result
	EventBus.stat_changed.emit(Stats.List.MAX_TOKENS_AMOUNT , result)

func revert() -> void:
	if !is_permanent:
		var result = add_to_player_stats(Stats.List.MAX_TOKENS_AMOUNT, -amount, lesser, 1)
		#var result = Global.run_stats.player_stats[Stats.List.MAX_TOKENS_AMOUNT] - amount
		#if result < 0:
			#result = 0
		#Global.run_stats.player_stats[Stats.List.MAX_TOKENS_AMOUNT] = result
		EventBus.stat_changed.emit(Stats.List.MAX_TOKENS_AMOUNT , result)
