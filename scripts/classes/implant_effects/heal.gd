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
	var max_health = Global.run_stats.player_stats[Stats.List.MAX_HEALTH]
	var base_heal = Global.run_stats.player_stats[Stats.List.BASE_HEAL]
	var extra_base_heal = Global.implant_manager.extra_stats[Stats.List.BASE_HEAL]
	if heal_amount == 0:
		heal_amount = int(max_health * (base_heal + extra_base_heal)/100)
	else:
		match mode:
			Mode.FLAT:
				heal_amount = int(heal_amount)
			Mode.PERCENT:
				heal_amount = int(max_health * heal_amount / 100.0)
	add_to_player_stats(Stats.List.CURRENT_HEALTH, heal_amount, greater, Global.run_stats.player_stats[Stats.List.MAX_HEALTH])
	Global.player_stats_bar.heal(heal_amount)
	
	#EventBus.healed.emit(amount)

func revert() -> void:
	print('a')
