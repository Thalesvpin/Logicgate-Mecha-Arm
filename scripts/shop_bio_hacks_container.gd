extends PanelContainer

@onready var implants_holder: VBoxContainer = $HBoxContainer/ImplantsHolder

const SHOP_BIO_HACK_ITEM = preload("uid://biquah0t1pge8")

var implants: Array[Implant]

func _ready() -> void:
	pass

func refresh() -> void:
	randomize_implants()
	add_implants()

func randomize_implants() -> void:
	var implant1 = get_random_implant()
	var implant2 = get_random_implant(implant1)
	implants.append(implant1)
	implants.append(implant2)
	

func get_random_implant(last = null) -> Implant:
	var list: Array[Implant]
	var chance
	var result
	
	chance = Global.random.next() % 100
	var chance1 = chance
	if chance < 40:
		list = Global.bh_commom
		if list == []:
			printerr('n tem raridade comum')
	elif chance < 70:
		list = Global.bh_rare
		if list == []:
			printerr('n tem raridade raro')
	elif chance < 90:
		list = Global.bh_ultra_rare
		if list == []:
			printerr('n tem raridade ultra raro')
	else:
		list = Global.bh_legendary
		if list == []:
			printerr('n tem raridade lendario')
	
	chance = Global.random.next() % list.size()
	if last == list[chance]:
		result = get_random_implant(last)
	else:
		result = list[chance]
	return result

func add_implants() -> void:
	var imp1 = SHOP_BIO_HACK_ITEM.instantiate()
	var imp2 = SHOP_BIO_HACK_ITEM.instantiate()
	
	imp1.implant = implants[0]
	imp2.implant = implants[1]
	
	implants_holder.add_child(imp1)
	implants_holder.add_child(imp2)
	implants_holder.move_child(imp1, 0)
