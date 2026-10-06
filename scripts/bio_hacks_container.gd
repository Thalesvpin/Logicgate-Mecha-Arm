extends PanelContainer

@onready var implant_count: Label = $MarginContainer/VBoxContainer/MarginContainer/PanelContainer/TitleBar/ImplantCount
@onready var implants_holder: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/ImplantsHolder

const IMPLANT_CARD = preload("uid://w1qq1p4375fn")

func _ready() -> void:
	update_counter()

func add_mod(resource: Implant):
	var implant = IMPLANT_CARD.instantiate()
	implant.resource = resource
	implants_holder.add_child(implant)
	EventBus.bio_hack_added.emit(resource)
	update_counter()

func update_counter() -> void:
	implant_count.text = str(Global.implant_manager.active_bio_hacks.size())+'/5'
