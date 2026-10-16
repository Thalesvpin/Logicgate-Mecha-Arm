extends ImplantCondition
class_name EnemyKilledCondition

@export var survived: bool = false

func is_met(_context = null) -> bool:
	if _context != null:
		if _context.name == 'Enemy':
			var health = _context['enemy'].stats[Stats.List.CURRENT_HEALTH]
			var dmg = _context['damage']
			if survived:
				return health - dmg > 0
			else:
				return health - dmg <= 0
	return false
