extends PanelContainer

@onready var open_pack_holder: VBoxContainer = $OpenPackHolder
@onready var pack_items: HBoxContainer = $OpenPackHolder/PackItems
@onready var packs: HBoxContainer = $Packs
@onready var spacer: Control = $Packs/Spacer
@onready var spacer_small: Control = $Packs/SpacerSmall
@onready var spacer_small_2: Control = $Packs/SpacerSmall2
@onready var spacer_2: Control = $Packs/Spacer2
@onready var pack_card: Pack = $Packs/PackCard
@onready var pack_card_small: PanelContainer = $Packs/PackCardSmall
@onready var pack_card_small_2: PanelContainer = $Packs/PackCardSmall2
@onready var pack_card_2: Pack = $Packs/PackCard2
@onready var reroll_card: PanelContainer = $Packs/RerollCard
@onready var pack_card_3: Pack = $Packs/PackCard3
@onready var pack_card_4: Pack = $Packs/PackCard4
@onready var instruction: RichTextLabel = $OpenPackHolder/Instruction

const OPEN_PACK_ITEM = preload("uid://8jbakdrf5e68")

var fade_list2: Array[PanelContainer]
var pack_list: Array[Pack]
var chosen_pack
var chosen_packs: Array
var choices_left

func _ready() -> void:
	EventBus.pack_item_chosen.connect(pack_item_chosen)
	EventBus.open_shop.connect(refresh)
	#EventBus.reroll_shop.connect(reroll)
	EventBus.skip_pack.connect(get_out_of_pack)
	
	pack_list.append(pack_card)
	pack_list.append(pack_card_2)
	pack_list.append(pack_card_3)
	pack_list.append(pack_card_4)
	for child in get_child(0).get_children():
		fade_list2.append(child)

func refresh() -> void:
	print('shop mid refresh()')
	reset_packs()
	for pack in pack_list:
		pack.randomize_pack()

func chose_pack(pack) -> void:
	var fade_list = fade_list2.duplicate()
	chosen_pack = pack
	chosen_packs.append(pack)
	choices_left = pack.choices_amount
	fade_list.erase(pack)
	var size = fade_list.size()
	var i = 0
	for item in fade_list:
		var tween = create_tween()
		tween.tween_interval(i * 0.15)
		tween.tween_property(item, 'modulate:a', 0, 0.2)
		
		if item == fade_list[size-1]:
			tween.tween_callback(
				func():
					item.hide()
					await get_tree().create_timer(0.25).timeout
					open_pack(pack)
			)
		else:
			tween.tween_callback(func(): item.hide())
		i += 1
		#tween.chain()
	Global.shop.pack_open()

func open_pack(pack: PanelContainer) -> void:
	pack.offset_transform_enabled = true
	var tween = create_tween().set_parallel()
	tween.tween_property(pack, 'offset_transform_position', Vector2(0,-1500), 0.5)
	#tween.tween_property(pack, 'offset_transform_position', Vector2(-pack.size.x/2,-800), 1)
	tween.tween_property(pack, 'offset_transform_scale', Vector2(7, 7), 0.5)
	var tween2 = create_tween().set_parallel(false)
	tween2.tween_property(pack, 'modulate:a', 0, 0.5)
	tween2.tween_callback(func(): 
		open_pack_holder.show()
		packs.hide()
		pack.hide()
		pack.modulate.a = 1
		pack.offset_transform_position = Vector2(0, 13)
		pack.offset_transform_scale = Vector2(1, 1)
	)
	
	for i in pack.items_amount:
		var item = OPEN_PACK_ITEM.instantiate()
		pack_items.add_child(item)
		item.load_implant(pack.drawn[i])
	instruction.text = 'Escolha até %d Implante' % pack.choices_amount
	if pack.choices_amount > 1:
		instruction.text += 's'

func close_pack() -> void:
	open_pack_holder.hide()
	Global.shop.pack_close()
	reset_open_pack()

func pack_item_chosen() -> void:
	choices_left -= 1
	if choices_left <= 0:
		get_out_of_pack()

func get_out_of_pack() -> void:
	choices_left = 0
	close_pack()
	show_packs()

func reset_open_pack() -> void:
	for child in pack_items.get_children():
		child.queue_free()

func show_packs() -> void:
	packs.show()
	reset_packs_visual()
	for pack in chosen_packs:
		pack.hide()
		match pack:
			pack_card:
				spacer.show()
			pack_card_3:
				spacer_small.show()
			pack_card_4:
				spacer_small_2.show()
			pack_card_2:
				spacer_2.show()

func reset_packs_visual() -> void:
	pack_card.show()
	pack_card_3.show()
	pack_card_4.show()
	pack_card_2.show()
	reroll_card.show()
	
	pack_card.modulate.a = 1.0
	pack_card_3.modulate.a = 1.0
	pack_card_4.modulate.a = 1.0
	pack_card_2.modulate.a = 1.0
	reroll_card.modulate.a = 1.0
	
	spacer.hide()
	spacer_small.hide()
	spacer_small_2.hide()
	spacer_2.hide()

func reset_packs() -> void:
	reset_packs_visual()
	chosen_pack = null
	chosen_packs = []
