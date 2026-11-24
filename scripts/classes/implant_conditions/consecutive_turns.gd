extends ImplantCondition
class_name ConsecutiveTurnsCondition

enum EffectType {STAT_CHANGE, ACTION}
##Progressive changes the way the condition works.[br]
##If false, the condition will be met every [amount] consecutive turns.[br]
##If true, the condition will be met every consecutive turn after the [amount]'st
@export var progressive: bool = false
@export_range(2, 99999, 1) var amount: int = 2
##Exemples:[br]STAT_CHANGE - damage increase, critic chance increase, etc[br]ACTION - take damage, repair shield, etc
@export var effect_type: EffectType

signal deferred_apply
var apply_on_turn_end: bool = false
var count: int = 0
var last_turn: int = 0
var triggered_this_turn: bool = false
var hooked: bool = false

func hook() -> void:
	if hooked:
		return
	hooked = true
	EventBus.battle_ended.connect(
		func():
			count = 0
			last_turn = 0
			triggered_this_turn = false
			apply_on_turn_end = false
			abort.emit()
	)
	EventBus.turn_ended.connect(
		func(who):
			#if !(who is String) && who != "player":
			if !(who is String):
				return
			if effect_type == EffectType.STAT_CHANGE && apply_on_turn_end:
				apply_on_turn_end = false
				deferred_apply.emit()
			if !triggered_this_turn && count > 0:
				count = 0
				last_turn = 0
				if effect_type == EffectType.STAT_CHANGE:
					abort.emit()
			triggered_this_turn = false
	)

func is_met(_context = null) -> bool:
	hook()
	var turn = Global.run_stats.current_turn
	if last_turn == turn:
		return false
	triggered_this_turn = true
	var consecutive = last_turn == turn - 1
	if effect_type == EffectType.STAT_CHANGE:
		var should_apply = false
		if count > 0 && !consecutive:
			abort.emit()
			count = 1
			last_turn = turn
			should_apply = true
		elif count == 0:
			count = 1
			last_turn = turn
			should_apply = true
		else:
			count += 1
			last_turn = turn
			should_apply = progressive
		if should_apply:
			apply_on_turn_end = true
		return false
	if consecutive:
		count += 1
		last_turn = turn
		if count >= amount:
			if !progressive:
				count = 0
			return true
	else:
		count = 1
		last_turn = turn
	return false
