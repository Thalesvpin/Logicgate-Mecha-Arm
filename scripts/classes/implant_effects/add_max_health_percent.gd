extends ImplantEffect
class_name AddMaxHealthPercentEffect

##To subtract, insert a nagative value
@export_custom(PROPERTY_HINT_NONE, 'suffix:%') var amount: float = 0
#@export var who: Variant
var aux

func apply(_context = null) -> void:
	aux = Global.run_stats.player_stats[Stats.List.MAX_HEALTH] * amount/100
	print('AddMaxHealthPercentEffect: ', aux)
	add_to_player_stats(Stats.List.MAX_HEALTH, aux, lesser, 1)
	var _max = Global.run_stats.player_stats[Stats.List.MAX_HEALTH]
	var current = Global.run_stats.player_stats[Stats.List.CURRENT_HEALTH]
	if aux > 0:
		add_to_player_stats(Stats.List.CURRENT_HEALTH, aux)
	if aux < 0 && current > _max:
		add_to_player_stats(Stats.List.CURRENT_HEALTH, -(current-_max), range, _max, _max)
	
	Global.player_stats_bar.update()

func revert() -> void:
	if !is_permanent:
		var _max = Global.run_stats.player_stats[Stats.List.MAX_HEALTH]
		var current = Global.run_stats.player_stats[Stats.List.CURRENT_HEALTH]
		if aux > 0:
			add_to_player_stats(Stats.List.CURRENT_HEALTH, aux)
		if aux < 0 && current > _max:
			add_to_player_stats(Stats.List.CURRENT_HEALTH, -(current-_max), range, _max, _max)
		#add_to_player_stats(Stats.List.MAX_HEALTH, -aux, lesser, 1)
		Global.player_stats_bar.update()
