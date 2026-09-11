extends ModifierEffect
class_name ChargedAttackEffect

@export var amount: int = 0

func apply() -> void:
	set_player_stat(Stats.List.CHARGED_ATTACK_ACTIVE_CHARGES, 0.0)
	
	Global.charged_attack_panel.deplete_charges()
	
	#EventBus.charged_charged_attack.emit()

func revert() -> void:
	pass
