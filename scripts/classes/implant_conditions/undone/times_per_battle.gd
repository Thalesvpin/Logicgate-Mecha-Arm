extends ImplantCondition
class_name TimesPerBattleCondition

@export var amount: int = 0
var count: int = 0
var linked: bool = false

func is_met(context = null) -> bool:
	if !linked:
		EventBus.battle_started.connect(reset)
		linked = true
	if count < amount:
		count += 1
		return true
	return false

func reset() -> void:
	count = 0
