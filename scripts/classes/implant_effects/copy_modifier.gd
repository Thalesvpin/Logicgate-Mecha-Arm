extends ImplantEffect
class_name CopyModifierEffect

@export var type: Implant.Type
var config: Array[ImplantExecutionConfig]
@export var prevent_consumable: bool = false
@export var prevent_disabled: bool = false
var implant: Implant
var callbacks: Array[Callable] = []
var extra: Array[ImplantExecutionConfig] = []
var ended := func(r = null): revert()

func apply(_context = null) -> void:
	var owner: Implant = Global.implant_manager.get_owned_implant_by_id(type, 64)
	var exclude: Array[Implant] = []
	if owner:
		exclude.append(owner)
	implant = Global.implant_manager.get_random_owned_implant(type, true, exclude)
	if implant == null:
		return
	if implant.consumable:
		for module in implant.config:
			for ef in module.effect:
				ef.apply(null)
		return
	config = implant.config
	for module in config:
		var cb := func(context = null):
			if implant == null or implant.disabled:
				return
			Implant.check_condition(context, module)
		callbacks.append(cb)
		EventBus.signals_list[module.trigger].connect(cb)
		if module.trigger == Trigger.Type.BATTLE_START:
			for ef in module.effect:
				ef.apply(null)
			extra.append(module)
	EventBus.battle_ended.connect(ended)

func revert() -> void:
	if EventBus.battle_ended.is_connected(ended):
		EventBus.battle_ended.disconnect(ended)
	for module in extra:
		for ef in module.effect:
			ef.revert()
	extra.clear()
	var i := 0
	for module in config:
		var sig: Signal = EventBus.signals_list[module.trigger]
		if i < callbacks.size() and sig.is_connected(callbacks[i]):
			sig.disconnect(callbacks[i])
		i += 1
	callbacks.clear()
	config = []
	implant = null
