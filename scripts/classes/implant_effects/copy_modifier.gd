extends ImplantEffect
class_name CopyModifierEffect

@export var type: Implant.Type
var config: Array[ImplantExecutionConfig]
@export var prevent_consumable: bool = true

func apply(_context = null) -> void:
	config = Global.implant_manager.get_random_owned_implant_config(type, prevent_consumable)
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
