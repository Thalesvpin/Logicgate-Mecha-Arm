extends PanelContainer

@onready var shop_mid_section: PanelContainer = $SubViewportContainer/SubViewport/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/ShopMidSection
@onready var shop_left_mods: PanelContainer = $SubViewportContainer/SubViewport/PanelContainer/HBoxContainer/ShopLeftMods
@onready var shop_right_mods: PanelContainer = $SubViewportContainer/SubViewport/PanelContainer/HBoxContainer/ShopRightMods

func _ready() -> void:
	connect_signals()

func connect_signals() -> void:
	EventBus.open_shop.connect(open)
	EventBus.close_shop.connect(close)

func open() -> void:
	show()
	shop_mid_section.refresh()
	shop_left_mods.refresh()
	shop_right_mods.refresh()

func close() -> void:
	hide()

func clean() -> void:
	pass

func reroll() -> void:
	pass
