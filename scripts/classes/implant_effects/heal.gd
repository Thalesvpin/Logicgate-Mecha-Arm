extends ImplantEffect
class_name HealEffect

##If set to 0, current run heal value will be used
@export var amount: float = 0:
	set(value):
		amount = max(value, 0)
##Mode is ignored if amount is set to 0
@export var mode: Mode

enum Mode {FLAT, PERCENT}

func apply(_context = null) -> void:
	#var result
	if amount == 0:
		amount = Global.run_stats.player_stats[Stats.List.BASE_HEAL]
		print('no')
	else:
		print('yes')
		match mode:
			Mode.FLAT:
				amount = int(amount)
			Mode.PERCENT:
				amount = int(Global.run_stats.player_stats[Stats.List.MAX_HEALTH] * amount/100)
	add_to_player_stats(Stats.List.CURRENT_HEALTH, amount, greater, Global.run_stats.player_stats[Stats.List.MAX_HEALTH])
	Global.player_stats_bar.heal(amount)
	
	#EventBus.healed.emit(amount)

func revert() -> void:
	print('a')
