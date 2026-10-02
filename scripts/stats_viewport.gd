extends PanelContainer
@onready var texture_rect: TextureRect = $Tabs/Bottom/CanvasGroup/HBoxContainer/TextureRect
@onready var texture_rect_2: TextureRect = $Tabs/Bottom/CanvasGroup/HBoxContainer/TextureRect2
@onready var texture_rect_3: TextureRect = $Tabs/Bottom/CanvasGroup/HBoxContainer/TextureRect3

const SELECTED_STATS_TAB = preload("uid://ulhofgmwnknp")
@onready var page_1: Control = $Page1
@onready var page_2: Control = $Page2
@onready var page_3: Control = $Page3
@onready var top_tab_btn_1: Button = $Tabs/Top/TopTabBtn1
@onready var top_tab_btn_2: Button = $Tabs/Top/TopTabBtn2
@onready var top_tab_btn_3: Button = $Tabs/Top/TopTabBtn3
var bot_tabs: Array[TextureRect]
@onready var sub_viewport: SubViewport = $Tabs/Bottom/SubViewport
@onready var transparent_gradient: TextureRect = $Tabs/Bottom/TransparentGradient

func _ready() -> void:
	bot_tabs = [texture_rect, texture_rect_2, texture_rect_3]
	transparent_gradient.texture = sub_viewport.get_texture()

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("test"):
		#for tab in bot_tabs:
			#tab.offset_left += 41

func change_page(page: int) -> void:
	page_1.hide()
	top_tab_btn_1.theme = null
	page_2.hide()
	top_tab_btn_2.theme = null
	page_3.hide()
	top_tab_btn_3.theme = null
	match page:
		1:
			page_1.show()
			top_tab_btn_1.theme = SELECTED_STATS_TAB
		2:
			page_2.show()
			top_tab_btn_2.theme = SELECTED_STATS_TAB
		3:
			page_3.show()
			top_tab_btn_3.theme = SELECTED_STATS_TAB

func _on_top_tab_1_pressed() -> void:
	change_page(1)

func _on_top_tab_2_pressed() -> void:
	change_page(2)

func _on_top_tab_3_pressed() -> void:
	change_page(3)
