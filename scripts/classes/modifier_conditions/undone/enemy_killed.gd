extends ModifierCondition
class_name EnemyKilledCondition

@export var percent: float = 0.5

func is_met() -> bool:
	return true
	#return context.owner.stats.health_percent() < percent
