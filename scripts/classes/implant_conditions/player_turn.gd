extends ImplantCondition
class_name  PlayerTurnCondition

func is_met(_context = null) -> bool:
	var result
	if _context is String:
		result = _context == 'player'
	elif _context is int:
		result = _context == 0
	else:
		return false
	print('\nplayer_turn: ', Global.run_stats.current_turn)
	print(_context, '\n')
	return result
