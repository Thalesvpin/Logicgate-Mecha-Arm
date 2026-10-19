extends PanelContainer

@onready var shop_mid_section: PanelContainer = $SubViewportContainer/SubViewport/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/ShopMidSection
@onready var shop_left_mods: PanelContainer = $SubViewportContainer/SubViewport/PanelContainer/HBoxContainer/ShopLeftMods
@onready var shop_right_mods: PanelContainer = $SubViewportContainer/SubViewport/PanelContainer/HBoxContainer/ShopRightMods

func _ready() -> void:
	connect_signals()

func connect_signals() -> void:
	EventBus.open_shop.connect(open)

func open()-> void:
	print('shop open()')
	show()
	print('a')
	shop_mid_section.refresh()
	print('b')
	shop_left_mods.refresh()
	shop_right_mods.refresh()
