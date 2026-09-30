extends ModifierEffect
class_name HeavyAttackEffect

@export var amount: int = 0

func apply(context = null) -> void:
	set_player_stat(Stats.List.HEAVY_ATTACK_ACTIVE_CHARGES, 0.0)
	
	Global.heavy_attack_panel.deplete_charges()
	
	#EventBus.charged_charged_attack.emit()

func revert() -> void:
	pass
