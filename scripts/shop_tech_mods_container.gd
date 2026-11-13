extends PanelContainer

@onready var implants_holder: VBoxContainer = $HBoxContainer/ImplantsHolder

const SHOP_TECH_MOD_ITEM = preload("uid://bt46rc7qxskx0")
const TM_1 = preload("uid://cswsbscbyhuh2")
const TM_2 = preload("uid://cmcqwoq53i712")

var implants: Array[Implant]

func _ready() -> void:
	EventBus.open_shop.connect(refresh)
	EventBus.close_shop.connect(clear)
	EventBus.reroll_shop.connect(refresh)

func refresh() -> void:
	implants = []
	clear()
	randomize_implants()
	add_implants()

func randomize_implants() -> void:
	var implant1 = get_random_implant()
	var implant2 = get_random_implant(implant1)
	implants.append(implant1)
	implants.append(implant2)

func clear() -> void:
	for child in implants_holder.get_children():
		if child.name == "Spacer":
			continue
		child.queue_free()

func get_random_implant(last = null) -> Implant:
	var list: Array[Implant]
	var chance
	var result
	
	chance = Global.random.next() % 100
	if chance < 40:
		list = Global.tm_commom
	elif chance < 70:
		list = Global.tm_rare
	elif chance < 90:
		list = Global.tm_ultra_rare
	else:
		list = Global.tm_legendary
	
	chance  = Global.random.next() % list.size()
	if last == list[chance]:
		result = get_random_implant(last)
	else:
		result = list[chance]
	return result

func add_implants() -> void:
	var imp1 = SHOP_TECH_MOD_ITEM.instantiate()
	var imp2 = SHOP_TECH_MOD_ITEM.instantiate()
	
	imp1.implant = implants[0]
	imp2.implant = implants[1]
	
	implants_holder.add_child(imp1)
	implants_holder.add_child(imp2)
	implants_holder.move_child(imp1, 0)
