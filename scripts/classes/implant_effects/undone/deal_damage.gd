extends ModifierEffect
class_name DealDamageEffect

##To subtract add a nagative value
@export var amount: int = 0

func apply() -> void:
	Global.run_stats.max_health += amount

func revert() -> void:
	if !is_permanent:
		Global.run_stats.max_health -= amount
