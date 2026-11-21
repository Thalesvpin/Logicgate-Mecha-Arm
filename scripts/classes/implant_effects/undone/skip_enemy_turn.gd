extends ImplantEffect
class_name SkipEnemyTurnEffect

@export var amount: int = 1

func apply(_context = null) -> void:
	Global.turn_manager.skip_turn(amount)

func revert() -> void:
	pass
