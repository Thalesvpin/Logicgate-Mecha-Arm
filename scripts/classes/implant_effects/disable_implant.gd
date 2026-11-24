extends ImplantEffect
class_name DisableImplantEffect

@export var type: Implant.Type
@export var prevent_consumable: bool = false
var implant: Implant
var ended := func(_r = null): revert()

func apply(_context = null) -> void:
	var owner: Implant = Global.implant_manager.get_owned_implant_by_id(Implant.Type.BIO_HACK, 64)
	var exclude: Array[Implant] = []
	if owner:
		exclude.append(owner)
	implant = Global.implant_manager.get_random_owned_implant(type, prevent_consumable, exclude)
	if implant == null:
		return
	implant.disable()
	set_card(implant, true)
	if not EventBus.battle_ended.is_connected(ended):
		EventBus.battle_ended.connect(ended)

func revert() -> void:
	if EventBus.battle_ended.is_connected(ended):
		EventBus.battle_ended.disconnect(ended)
	if implant == null:
		return
	implant.disable(false)
	set_card(implant, false)
	implant = null

func set_card(target: Implant, off: bool) -> void:
	for card in Global.bio_hacks_container.implants_holder.get_children():
		if card.resource == target:
			card.disable() if off else card.enable()
