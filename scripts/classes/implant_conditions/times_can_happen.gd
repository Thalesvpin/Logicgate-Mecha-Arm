extends ImplantCondition
class_name TimesCanHappenCondition

enum Per {BATTLE, TURN}

@export var amount: int = 0
@export var per: Per = Per.BATTLE
var count: int = 0

func is_met(context = null) -> bool:
	if count < amount:
		count += 1
		if count == 1:
			match per:
				Per.BATTLE:
					EventBus.battle_ended.connect(reset_count)
				Per.TURN:
					EventBus.turn_ended.connect(reset_count)
		return true
	return false

func reset_count() -> void:
	count = 0
