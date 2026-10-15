extends PanelContainer

@onready var implants_holder: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/ImplantsHolder
@onready var implant_count: Label = $MarginContainer/VBoxContainer/MarginContainer/PanelContainer/TitleBar/ImplantCount

const IMPLANT_CARD = preload("uid://w1qq1p4375fn")

func _ready() -> void:
	Global.tech_mods_container = self
	#EventBus.tech_mod_added.connect(add_implant)
	update_counter()

func add_implant(resource: Implant):
	var implant = IMPLANT_CARD.instantiate()
	implant.resource = resource
	implants_holder.add_child(implant)
	implant.load_resource()
	#EventBus.tech_mod_added.emit(resource)
	update_counter()

func update_counter() -> void:
	implant_count.text = str(Global.implant_manager.active_tech_mods.size())+'/5'
