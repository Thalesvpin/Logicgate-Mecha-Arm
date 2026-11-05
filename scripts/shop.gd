extends PanelContainer

@onready var shop_mid_section: PanelContainer = $SubViewportContainer/SubViewport/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/ShopMidSection
@onready var shop_tech_mods_container: PanelContainer = $SubViewportContainer/SubViewport/PanelContainer/HBoxContainer/ShopTechModsContainer
@onready var shop_bio_hacks_container: PanelContainer = $SubViewportContainer/SubViewport/PanelContainer/HBoxContainer/ShopBioHacksContainer

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

func clean() -> void:
	pass

func reroll() -> void:
	pass

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
