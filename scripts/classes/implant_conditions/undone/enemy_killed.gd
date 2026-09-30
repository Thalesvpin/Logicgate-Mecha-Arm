extends ImplantCondition
class_name EnemyKilledCondition

@export var percent: float = 0.5

func is_met(context = null) -> bool:
	return true
	#return context.owner.stats.health_percent() < percent
