extends PanelContainer

@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer
@onready var panel_container: PanelContainer = $SubViewportContainer/SubViewport/PanelContainer
@onready var implant_count: Label = $SubViewportContainer/SubViewport/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/PanelContainer/TitleBar/ImplantCount
@onready var implants_holder: VBoxContainer = $SubViewportContainer/SubViewport/PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ImplantsHolder

const IMPLANT_CARD = preload("uid://w1qq1p4375fn")

func _ready() -> void:
	Global.bio_hacks_container = self
	#EventBus.bio_hack_added.connect(add_implant)
	update_counter()
	sub_viewport_container.custom_minimum_size = panel_container.get_combined_minimum_size()

func add_implant(resource: Implant):
	var implant = IMPLANT_CARD.instantiate()
	implant.resource = resource
	implants_holder.add_child(implant)
	implant.load_resource()
	update_counter()

func remove_implant(implant) -> void:
	implants_holder.remove_child(implant)
	update_counter()

func update_counter() -> void:
	implant_count.text = str(Global.implant_manager.active_bio_hacks.size())+'/5'
