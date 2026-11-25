extends ImplantEffect
class_name HealEffect

##If set to 0, current run heal value will be used
@export var amount: float = 0:
	set(value):
		amount = max(value, 0)
##Mode is ignored if amount is set to 0
@export var mode: Mode

enum Mode {PERCENT, FLAT}

func apply(_context = null) -> void:
	var heal_amount := amount
	if heal_amount == 0:
		heal_amount = Global.run_stats.player_stats[Stats.List.BASE_HEAL] + Global.implant_manager.extra_stats[Stats.List.BASE_HEAL]
	else:
		match mode:
			Mode.FLAT:
				heal_amount = int(heal_amount)
			Mode.PERCENT:
				heal_amount = int(Global.run_stats.player_stats[Stats.List.MAX_HEALTH] * heal_amount / 100.0)
	add_to_player_stats(Stats.List.CURRENT_HEALTH, heal_amount, greater, Global.run_stats.player_stats[Stats.List.MAX_HEALTH])
	Global.player_stats_bar.heal(heal_amount)
	
	#EventBus.healed.emit(amount)

func revert() -> void:
	print('a')
