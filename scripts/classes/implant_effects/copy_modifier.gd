extends ImplantEffect
class_name CopyModifierEffect

@export var type: Implant.Type
@export var prevent_consumable: bool = false
@export var prevent_disabled: bool = true
@export var exclude_self: bool = true
var source_trigger: Trigger.Type
var implant: Implant
var copied: Array[ImplantExecutionConfig] = []
var callbacks: Array[Callable] = []
var ended := func(_r = null): revert()

func apply(context = null) -> void:
	revert()
	implant = Global.implant_manager.get_random_owned_implant(type, prevent_consumable, exclude(), prevent_disabled)
	if implant == null:
		return
	for module in implant.config:
		var mod: ImplantExecutionConfig = module.duplicate(true)
		copied.append(mod)
		var cb := func(ctx = null):
			if implant == null || (prevent_disabled && implant._disabled):
				return
			Implant.check_condition(ctx, mod)
		callbacks.append(cb)
		EventBus.signals_list[mod.trigger].connect(cb)
		if mod.trigger == source_trigger:
			Implant.check_condition(context, mod)
	if not EventBus.battle_ended.is_connected(ended):
		EventBus.battle_ended.connect(ended)

func exclude() -> Array[Implant]:
	var exclude: Array[Implant] = []
	if not exclude_self:
		return exclude
	for source in [Global.implant_manager.active_tech_mods, Global.implant_manager.active_bio_hacks]:
		for owned in source:
			for module in owned.config:
				if self in module.effect:
					exclude.append(owned)
					break
	return exclude

func revert() -> void:
	if EventBus.battle_ended.is_connected(ended):
		EventBus.battle_ended.disconnect(ended)
	for i in copied.size():
		for ef in copied[i].effect:
			ef.revert()
		var sig: Signal = EventBus.signals_list[copied[i].trigger]
		if i < callbacks.size() && sig.is_connected(callbacks[i]):
			sig.disconnect(callbacks[i])
	copied.clear()
	callbacks.clear()
	implant = null
