extends ModifierCondition
class_name EnemyKilledCondition

@export var percent: float = 0.5

func is_met(context) -> bool:
	return context.owner.stats.health_percent() < percent
