extends ModifierEffect
class_name AddMaxHealthEffect

##To subtract add a nagative value
@export var amount: int = 0

func apply(context) -> void:
	Global.run_stats.max_health += amount

func revert(context) -> void:
	if !is_permanent:
		Global.run_stats.max_health -= amount
