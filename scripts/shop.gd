extends PanelContainer

@onready var shop_mid_section: PanelContainer = $SubViewportContainer/SubViewport/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/ShopMidSection
@onready var shop_tech_mods_container: PanelContainer = $SubViewportContainer/SubViewport/PanelContainer/HBoxContainer/ShopTechModsContainer
@onready var shop_bio_hacks_container: PanelContainer = $SubViewportContainer/SubViewport/PanelContainer/HBoxContainer/ShopBioHacksContainer
@onready var shop_buttons_panel: PanelContainer = $SubViewportContainer/SubViewport/PanelContainer/HBoxContainer/VBoxContainer/ShopButtonsPanel
@onready var pack_button_panel: PanelContainer = $SubViewportContainer/SubViewport/PanelContainer/HBoxContainer/VBoxContainer/PackButtonPanel

@export var lateral_implants_speed: float = 0.8
@export var lateral_implants_offset: int = 200

func _ready() -> void:
	Global.shop = self
	connect_signals()

func connect_signals() -> void:
	EventBus.open_shop.connect(open)
	EventBus.close_shop.connect(close)

func open() -> void:
	show()
	#shop_mid_section.refresh()
	#shop_tech_mods_container.refresh()
	#shop_bio_hacks_container.refresh()

func close() -> void:
	hide()

func pack_open() -> void:
	hide_implants()
	change_bot_btns()

func pack_close() -> void:
	show_implants()
	change_bot_btns()

func change_bot_btns() -> void:
	var object_down
	var object_up
	var tween = create_tween()
	tween.set_parallel(false)
	tween.set_ease(Tween.EASE_OUT)
	if shop_buttons_panel.is_visible_in_tree():
		object_down = shop_buttons_panel
		object_up = pack_button_panel
	else:
		object_down = pack_button_panel
		object_up = shop_buttons_panel
	tween.tween_property(object_down, 'offset_transform_position:y', object_down.size.y, 0.5)
	tween.tween_callback(
		func():
			object_down.hide()
			object_up.show()
	)
	tween.tween_interval(0.2)
	tween.tween_property(object_up, 'offset_transform_position:y', 0, 0.5)

func hide_implants() -> void:
	var tween = create_tween().set_parallel()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(shop_tech_mods_container, 'offset_transform_position:x', -(shop_tech_mods_container.size.x+20), lateral_implants_speed)
	tween.tween_property(shop_bio_hacks_container, 'offset_transform_position:x', shop_bio_hacks_container.size.x+20, lateral_implants_speed)

func show_implants() -> void:
	var tween = create_tween().set_parallel()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(shop_tech_mods_container, 'offset_transform_position:x', 0, lateral_implants_speed)
	tween.tween_property(shop_bio_hacks_container, 'offset_transform_position:x', 0, lateral_implants_speed)
