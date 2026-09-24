extends ModifierEffect
class_name TakeDamageEffect

@export var amount: int = 0:
	set(value):
		amount = max(value, 0)

func apply() -> void:
	var mitigation = calculate_mitigation()
	add_to_player_stats(Stats.List.CURRENT_HEALTH, -(amount-mitigation), lesser, 0)
	
	Global.player_stats_bar.take_damage(amount-mitigation)
	#EventBus.damage_taken.emit(amount)

func revert() -> void:
	pass

func calculate_mitigation() -> int:
	if Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD_COUNT] > 0:
		#return amount - 0
		return 0
	else:
		return 0
	
	pass
