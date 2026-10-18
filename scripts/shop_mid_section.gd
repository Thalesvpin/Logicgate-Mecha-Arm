extends PanelContainer

@onready var open_pack_holder: HBoxContainer = $OpenPackHolder
@onready var packs: HBoxContainer = $Packs

const OPEN_PACK_ITEM = preload("uid://8jbakdrf5e68")

var fade_list2: Array[PanelContainer]
var pack_list: Array[Pack]

func _ready() -> void:
	for child in get_child(0).get_children():
		fade_list2.append(child)
		if child.get_class() == 'Pack':
			pack_list.append(child)

func refresh() -> void:
	for pack in pack_list:
		pack.randomize_options()

func chose_pack(pack) -> void:
	var fade_list = fade_list2.duplicate()
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

func open_pack(pack: PanelContainer) -> void:
	pack.offset_transform_enabled = true
	var tween = create_tween().set_parallel()
	tween.tween_property(pack, 'offset_transform_position', Vector2(-pack.size.x/2,-800), 1)
	tween.tween_property(pack, 'scale', Vector2(7, 7), 1)
	var tween2 = create_tween()
	tween2.tween_property(pack, 'modulate:a', 0, 0.5)
	tween2.tween_callback(func(): pack.hide())
	
	open_pack_holder.show()
	packs.hide()
	for i in pack.items_amount:
		var pack_item = OPEN_PACK_ITEM.instantiate()
		pack_item.load_implant(pack.chosen[i])
		open_pack_holder.add_child(pack_item)
