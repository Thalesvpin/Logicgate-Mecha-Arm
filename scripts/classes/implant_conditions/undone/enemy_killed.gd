extends ImplantCondition
class_name EnemyKilledCondition

@export var survived: bool = false

func is_met(context = null) -> bool:
	return true
	#return context.owner.stats.health_percent() < percent
