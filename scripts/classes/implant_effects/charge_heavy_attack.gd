extends ImplantEffect
class_name ChargeHeavyAttackEffect

@export_range(0, 4, 1) var amount: int = 0

func apply(_context = null) -> void:
	var max_charges = get_player_stat(Stats.List.MAX_HEAVY_ATTACK_CHARGES)
	if amount == 0:
		add_to_player_stats(Stats.List.CURRENT_HEAVY_ATTACK_CHARGES, Global.run_stats.player_stats[Stats.List.HEAVY_ATTACK_CHARGE_AMOUNT], range, 0, max_charges)
	else:
		add_to_player_stats(Stats.List.CURRENT_HEAVY_ATTACK_CHARGES, amount, range, 0, max_charges)
	print('charge: ', Global.run_stats.player_stats[Stats.List.HEAVY_ATTACK_CHARGE_AMOUNT])
	print('quanto ja tem: ', Global.run_stats.player_stats[Stats.List.CURRENT_HEAVY_ATTACK_CHARGES])
	Global.heavy_attack_panel.add_charges()

func revert() -> void:
	pass
