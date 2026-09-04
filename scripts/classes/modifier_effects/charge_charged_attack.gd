extends ModifierEffect
class_name ChargeChargedAttackEffect

@export var amount: int = 0

func apply() -> void:
	var max_charges = get_player_stat(Stats.List.CHARGED_ATTACK_MAX_CHARGES)
	add_to_player_stats(Stats.List.CHARGED_ATTACK_ACTIVE_CHARGES, amount, range, 0, max_charges)
	EventBus.charged_charged_attack.emit()

func revert() -> void:
	pass
