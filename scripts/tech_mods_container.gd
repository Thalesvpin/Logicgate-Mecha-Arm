extends PanelContainer

@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer
@onready var panel_container: PanelContainer = $SubViewportContainer/SubViewport/PanelContainer
@onready var implants_holder: VBoxContainer = $SubViewportContainer/SubViewport/PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ImplantsHolder
@onready var implant_count: Label = $SubViewportContainer/SubViewport/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/PanelContainer/TitleBar/ImplantCount

const IMPLANT_CARD = preload("uid://w1qq1p4375fn")

func _ready() -> void:
	Global.tech_mods_container = self
	#EventBus.tech_mod_added.connect(add_implant)
	update_counter()
	sub_viewport_container.custom_minimum_size = panel_container.get_combined_minimum_size()

func add_implant(resource: Implant):
	var implant = IMPLANT_CARD.instantiate()
	implant.resource = resource
	implants_holder.add_child(implant)
	implant.load_resource()
	implant.is_owned = true
	#EventBus.tech_mod_added.emit(resource)
	update_counter()

func remove_implant(implant) -> void:
	implants_holder.remove_child(implant)
	update_counter()

func update_counter() -> void:
	implant_count.text = str(Global.implant_manager.active_tech_mods.size())+'/5'
