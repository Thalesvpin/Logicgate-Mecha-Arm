extends ModifierEffect
class_name TakeDamageEffect

@export var amount: int = 0:
	set(value):
		amount = max(value, 0)

func apply() -> void:
	var result = add_to_player_stats(Stats.List.CURRENT_HEALTH, -amount, lesser, 0)
	#var result = Global.run_stats.player_stats[Stats.List.CURRENT_HEALTH] - amount
	#if result < 0:
		#result = 0
	#Global.run_stats.player_stats[Stats.List.CURRENT_HEALTH] = result
	EventBus.damage_taken.emit(result)

func revert() -> void:
	pass
