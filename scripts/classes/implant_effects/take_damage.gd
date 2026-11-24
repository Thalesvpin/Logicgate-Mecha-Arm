extends ImplantEffect
class_name TakeDamageEffect

@export var amount: int = 0:
	set(value):
		amount = max(value, 0)

func apply(_context = null) -> void:
	var mitigation = calculate_mitigation(amount)
	add_to_player_stats(Stats.List.CURRENT_HEALTH, -(amount-mitigation), lesser, 0)
	
	var attacker = _context.get("attacker") if _context is Dictionary else null
	Global.player_stats_bar.take_damage(amount - mitigation, attacker)

func revert() -> void:
	pass

func calculate_mitigation(dmg) -> int:
	if Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD] > 0:
		Global.player_stats_bar.damage_shield(1)
		return dmg * (float(Global.run_stats.player_stats[Stats.List.MITIGATION_PERCENT] + Global.implant_manager.extra_stats[Stats.List.MITIGATION_PERCENT])/100)
	else:
		return 0
