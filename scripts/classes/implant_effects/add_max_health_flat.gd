extends ImplantEffect
class_name AddMaxHealthFlatEffect

##To subtract, insert a nagative value
@export var amount: int = 0
#@export var who: Variant

func apply(_context = null) -> void:
	add_to_player_stats(Stats.List.MAX_HEALTH, amount, lesser, 1)
	
	var _max = Global.run_stats.player_stats[Stats.List.MAX_HEALTH]
	var current = Global.run_stats.player_stats[Stats.List.CURRENT_HEALTH]
	if amount > 0:
		add_to_player_stats(Stats.List.CURRENT_HEALTH, amount)
	if amount < 0 && current > _max:
		add_to_player_stats(Stats.List.CURRENT_HEALTH, -(current-_max), range, _max, _max)
	Global.player_stats_bar.update()

func revert() -> void:
	if !is_permanent:
		add_to_player_stats(Stats.List.MAX_HEALTH, -amount, lesser, 1)
		var _max = Global.run_stats.player_stats[Stats.List.MAX_HEALTH]
		var current = Global.run_stats.player_stats[Stats.List.CURRENT_HEALTH]
		if amount > 0:
			add_to_player_stats(Stats.List.CURRENT_HEALTH, amount)
		if amount < 0 && current > _max:
			add_to_player_stats(Stats.List.CURRENT_HEALTH, -(current-_max), range, _max, _max)
		Global.player_stats_bar.update()
