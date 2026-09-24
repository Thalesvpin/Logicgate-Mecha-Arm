extends PanelContainer

@onready var implants_holder: VBoxContainer = $HBoxContainer/ImplantsHolder

const SHOP_TECH_MOD_ITEM = preload("uid://bt46rc7qxskx0")

var implants: Array[Implant]

func _ready() -> void:
	randomize_implants()
	#add_implants()

func randomize_implants() -> void:
	pass

func add_implants() -> void:
	var imp1 = SHOP_TECH_MOD_ITEM.instantiate()
	var imp2 = SHOP_TECH_MOD_ITEM.instantiate()
	
	imp1.resource = implants[0]
	imp2.resource = implants[1]
	
	implants_holder.add_child(imp1)
	implants_holder.add_child(imp2)
	move_child(imp1, 0)
