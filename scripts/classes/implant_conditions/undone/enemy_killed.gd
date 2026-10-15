extends ImplantCondition
class_name EnemyKilledCondition

@export var survived: bool = false

func is_met(_context = null) -> bool:
	if _context != null:
		if _context.name == 'Enemy':
			var health = _context.stats[Stats.List.CURRENT_HEALTH]
			a
	return true
	#return _context.owner.stats.health_percent() < percent
