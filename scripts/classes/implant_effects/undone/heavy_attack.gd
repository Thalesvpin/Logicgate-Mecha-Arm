extends ImplantEffect
class_name HeavyAttackEffect

@export var amount: int = 0

func apply(_context = null) -> void:
	print('heavy attack try: ', Global.run_stats.player_stats[Stats.List.CURRENT_HEAVY_ATTACK_CHARGES])
	if Global.run_stats.player_stats[Stats.List.CURRENT_HEAVY_ATTACK_CHARGES] < Global.run_stats.player_stats[Stats.List.MAX_HEAVY_ATTACK_CHARGES]:
		print('heavy attack not charged')
		return
	set_player_stat(Stats.List.CURRENT_HEAVY_ATTACK_CHARGES, 0.0)
	
	Global.heavy_attack_panel.deplete_charges()
	var effect = DealDamageEffect.new()
	#effect.amount = Global.run_stats.player_stats[Stats.List.HEAVY_ATTACK_MULT]
	#EventBus.charged_charged_attack.emit()

func revert() -> void:
	pass
