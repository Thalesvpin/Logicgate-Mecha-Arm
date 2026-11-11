extends PanelContainer

@onready var implants_holder: VBoxContainer = $HBoxContainer/ImplantsHolder

const SHOP_BIO_HACK_ITEM = preload("uid://biquah0t1pge8")

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
	
	while list.size() == 0:
		chance = Global.random.next() % 100
		if chance < 40:
			list = Global.bh_commom
			if list == []:
				printerr('n tem bio hack comum')
		elif chance < 70:
			list = Global.bh_rare
			if list == []:
				printerr('n tem bio hack raro')
		elif chance < 90:
			list = Global.bh_ultra_rare
			if list == []:
				printerr('n tem raribio hack ultra raro')
		else:
			list = Global.bh_legendary
			if list == []:
				printerr('n tem bio hack lendario')
	
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
