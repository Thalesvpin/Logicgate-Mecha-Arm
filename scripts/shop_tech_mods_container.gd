extends PanelContainer

@onready var implants_holder: VBoxContainer = $HBoxContainer/ImplantsHolder

const SHOP_TECH_MOD_ITEM = preload("uid://bt46rc7qxskx0")
const TM_1 = preload("uid://cswsbscbyhuh2")
const TM_2 = preload("uid://cmcqwoq53i712")

var implants: Array[Implant]

func _ready() -> void:
	randomize_implants()
	add_implants()

func randomize_implants() -> void:
	implants.append(TM_1)
	implants.append(TM_2)

func add_implants() -> void:
	var imp1 = SHOP_TECH_MOD_ITEM.instantiate()
	var imp2 = SHOP_TECH_MOD_ITEM.instantiate()
	
	imp1.implant = implants[0]
	imp2.implant = implants[1]
	
	implants_holder.add_child(imp1)
	implants_holder.add_child(imp2)
	implants_holder.move_child(imp1, 0)
