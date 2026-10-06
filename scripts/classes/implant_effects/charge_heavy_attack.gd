extends ModifierEffect
class_name ChargeHeavyAttackEffect

@export_range(0, 100, 25, 'suffix:%') var amount: int = 1

func apply(context = null) -> void:
	var max_charges = get_player_stat(Stats.List.HEAVY_ATTACK_MAX_CHARGES)
	add_to_player_stats(Stats.List.HEAVY_ATTACK_ACTIVE_CHARGES, amount, range, 0, max_charges)
	
	Global.heavy_attack_panel.add_charges(Global.run_stats.player_stats[Stats.List.HEAVY_ATTACK_CHARGE_AMOUNT])
	
	#EventBus.charged_charged_attack.emit()

func revert() -> void:
	pass
