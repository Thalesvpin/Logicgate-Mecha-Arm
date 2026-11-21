extends ImplantEffect
class_name DisableImplantEffect

@export var type: Implant.Type
@export var prevent_consumable: bool = false
var implant: Implant

func apply(_context = null) -> void:
	implant = Global.implant_manager.get_random_owned_implant(type, prevent_consumable)
	implant.disable()
	EventBus.battle_ended.connect(revert)

func revert() -> void:
	implant.disable(false)
	implant = null
