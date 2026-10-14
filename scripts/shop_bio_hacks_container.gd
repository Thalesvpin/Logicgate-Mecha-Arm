extends PanelContainer

@onready var implants_holder: VBoxContainer = $HBoxContainer/ImplantsHolder

const SHOP_BIO_HACK_ITEM = preload("uid://biquah0t1pge8")

var implants: Array[Implant]

func _ready() -> void:
	randomize_implants()
	#add_implants()

func randomize_implants() -> void:
	pass
	#var implant1 = get_random_implant()
	#var implant2 = get_random_implant(implant1)
	#implants.append(implant1)
	#implants.append(implant2)
	

func get_random_implant(last = null) -> Implant:
	var list: Array[Implant]
	var chance
	var result
	
	chance = Global.random.next() % 100
	if chance < 40:
		list = Global.bh_commom
	elif chance < 70:
		list = Global.bh_rare
	elif chance < 90:
		list = Global.bh_ultra_rare
	else:
		list = Global.bh_legendary
	
	chance  = Global.random.next() % list.size()
	if last == list[chance]:
		result = get_random_implant(last)
	else:
		result = list[chance]
	return result

func add_implants() -> void:
	var imp1 = SHOP_BIO_HACK_ITEM.instantiate()
	var imp2 = SHOP_BIO_HACK_ITEM.instantiate()
	
	imp1.resource = implants[0]
	imp2.resource = implants[1]
	
	implants_holder.add_child(imp1)
	implants_holder.add_child(imp2)
	move_child(imp1, 0)
