extends ImplantEffect
class_name CopyModifierEffect

@export var type: Implant.Type
var config: Array[ImplantExecutionConfig]
@export var prevent_consumable: bool = false
@export var prevent_disabled: bool = false
var implant: Implant

func apply(_context = null) -> void:
	implant = Global.implant_manager.get_random_owned_implant(type, prevent_consumable)
	if prevent_disabled:
		while implant.disabled:
			implant = Global.implant_manager.get_random_owned_implant(type, prevent_consumable)
	config = implant.config
	connect_triggers()

func revert() -> void:
	disconnect_triggers()
	config = []

func connect_triggers() -> void:
	for module in config:
		for condition in module.conditions:
			for ef in module.effect:
				condition.abort.connect(ef.revert)
		#for ef in module.effect:
				EventBus.signals_list[module.trigger].connect(Implant.check_condition.bind(module))

func disconnect_triggers() -> void:
	for module in config:
		for condition in module.conditions:
			for ef in module.effect:
				condition.abort.disconnect(ef.revert)
				EventBus.signals_list[module.trigger].disconnect(Implant.check_condition.bind(module))
