extends PanelContainer

@onready var modifiers_holder: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/ModifiersHolder

const MODIFIER_CARD = preload("uid://w1qq1p4375fn")

func add_mod(resource: Modifier):
	var mod = MODIFIER_CARD.instantiate()
	mod.resource = resource
	modifiers_holder.add_child(mod)
	EventBus.tech_mod_added.emit(resource)
