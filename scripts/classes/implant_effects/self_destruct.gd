extends ImplantEffect
class_name SelfDestructEffect

@export var implant_id: int
@export var type: Implant.Type

func apply(_context = null) -> void:
	var implant = Global.implant_manager.get_owned_implant_by_id(type, implant_id)
	if implant == null:
		return
	if type == Implant.Type.TECH_MOD:
		Global.implant_manager.remove_tech_mod_2(implant)
	else:
		Global.implant_manager.remove_bio_hack_2(implant)

func revert() -> void:
	pass
