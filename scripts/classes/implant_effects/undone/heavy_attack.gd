extends ImplantEffect
class_name HeavyAttackEffect

@export var amount: int = 0

func apply(_context = null) -> void:
	if Global.run_stats.player_stats[Stats.List.CURRENT_HEAVY_ATTACK_CHARGES] >= Global.run_stats.player_stats[Stats.List.MAX_HEAVY_ATTACK_CHARGES]:
		return
	set_player_stat(Stats.List.HEAVY_ATTACK_ACTIVE_CHARGES, 0.0)
	
	Global.heavy_attack_panel.deplete_charges()
	
	#EventBus.charged_charged_attack.emit()

func revert() -> void:
	pass
