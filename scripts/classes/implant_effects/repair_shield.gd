extends ImplantEffect
class_name RepairShieldEffect

##VALUE repairs amount durability. UNIT repairs amount shields to max
@export var mode: Mode
@export var amount: int = 0:
	set(value):
		amount = max(value, 0)

enum Mode {VALUE, UNIT, PERCENT}

func apply(_context = null) -> void:
	var result
	match mode:
		Mode.VALUE:
			result = add_to_player_stats(Stats.List.CURRENT_SHIELD, amount, greater, Global.run_stats.player_stats[Stats.List.MAX_SHIELD]*Global.run_stats.player_stats[Stats.List.MAX_SHIELD_COUNT])
		Mode.UNIT:
			var active = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD_COUNT]
			var max_p_unit = Global.run_stats.player_stats[Stats.List.MAX_SHIELD]
			var max_active = active * max_p_unit
			var current = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD]
			
			if current == max_active:
				amount = max_p_unit
			else:
				amount = max_active - current
			result = add_to_player_stats(Stats.List.CURRENT_SHIELD, amount, greater, max_p_unit * Global.run_stats.player_stats[Stats.List.MAX_SHIELD_COUNT])
		Mode.PERCENT:
			var max_p_unit = Global.run_stats.player_stats[Stats.List.MAX_SHIELD]
			var max_count = Global.run_stats.player_stats[Stats.List.MAX_SHIELD_COUNT]
			var _max = max_p_unit * max_count
			result = add_to_player_stats(Stats.List.CURRENT_SHIELD, _max * amount/100, greater, _max)
	Global.player_stats_bar.repair_shield(result)
	
	#EventBus.repaired_shield.emit(amount)

func revert() -> void:
	pass
