extends StatUpgrade

@onready var mitigation_value_label: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/MitigationValueLabel
@onready var current_values_container: HBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer
@onready var shield_strength_price_label: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer3/VBoxContainer/ShieldStrengthPrice
@onready var mitigation_price_label: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer3/VBoxContainer/MitigationPrice
@onready var buy_button_strength: TextureButton = $MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer2/MarginContainer/BuyButtonStrength
@onready var buy_button_mitigation: TextureButton = $MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer3/MarginContainer/BuyButtonMitigation
@onready var upgrade_value_mitigation: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/UpgradeValueMitigation

@export var preset_prices_mitigation: Array[int] = []
@export var action_after_preset_mitigation: PriceAction
@export var after_preset_value_mitigation: int = 0
@export var mitigation_increase: float
var choice_price: int = 0
enum Upgrade {STRENGHT, MITIGATION}
var upgrade_type: Upgrade
var upgrades_count_mitigation: int = 0
var current_price_mitigation: int
var current_price_strength: int

func ready() -> void:
	EventBus.shield_count.connect(update_value)
	current_price_strength = preset_prices[upgrades_count]
	current_price_mitigation = preset_prices_mitigation[upgrades_count_mitigation]

func upgrade() -> void:
	if withdraw_money():
		if upgrade_type == Upgrade.STRENGHT:
			var ef = AddShieldStrengthEffect.new()
			ef.amount = int(amount_per_upgrade)
			ef.apply()
			var ef2 = RepairShieldEffect.new()
			ef2.amount = int(amount_per_upgrade) * Global.run_stats.player_stats[Stats.List.MAX_SHIELD_COUNT]
			ef2.apply()
			upgrades_count += 1
		if upgrade_type == Upgrade.MITIGATION:
			var ef3 = AddMitigationPercentEffect.new()
			ef3.amount = mitigation_increase
			ef3.apply()
			upgrades_count_mitigation += 1
		update_price()
		update_value()

func update_price() -> void:
	if upgrade_type == Upgrade.STRENGHT:
		if upgrades_count < preset_prices.size():
			current_price_strength = preset_prices[upgrades_count]
		else:
			if action_after_preset == PriceAction.ADD:
				current_price_strength += after_preset_value
			if action_after_preset == PriceAction.MULTIPLY:
				current_price_strength *= after_preset_value
	shield_strength_price_label.text = '$ %d' % current_price_strength
	
	if upgrade_type == Upgrade.MITIGATION:
		if upgrades_count_mitigation < preset_prices_mitigation.size():
			current_price_mitigation = preset_prices_mitigation[upgrades_count_mitigation]
		else:
			if action_after_preset_mitigation == PriceAction.ADD:
				current_price_mitigation += after_preset_value_mitigation
			if action_after_preset_mitigation == PriceAction.MULTIPLY:
				current_price_mitigation *= after_preset_value_mitigation
	mitigation_price_label.text = '$ %d' % current_price_mitigation
	if Global.run_stats.player_stats[Stats.List.MITIGATION_PERCENT] >= 70:
		buy_button_mitigation.disabled = true
		mitigation_price_label.text = 'MAX'

func update_value() -> void:
	var aux = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD]
	var strength = Global.run_stats.player_stats[Stats.List.SHIELD_STRENGTH]
	var labels = current_values_container.get_children()
	var count = Global.run_stats.player_stats[Stats.List.MAX_SHIELD_COUNT]
	
	for i in range(count):
		labels[i].show()
		if i < count-1:
			labels[i].text = '%d/%d' % [strength, strength]
			aux -= strength
		else:
			labels[i].text = '%d/%d' % [aux, strength] 
	
	mitigation_value_label.text = ('%.1f' % (Global.run_stats.player_stats[Stats.List.MITIGATION_PERCENT] + Global.implant_manager.extra_stats[Stats.List.MITIGATION_PERCENT])).trim_suffix('.0') + '%'

func withdraw_money() -> bool:
	if Global.run_stats.player_stats[Stats.List.CURRENT_MONEY] < choice_price:
		return false
	var ef = AddMoneyEffect.new()
	ef.amount = -current_price
	ef.apply()
	return true

func _on_buy_button_strength_button_down() -> void:
	buy_btn = buy_button_strength
	upgrade_type = Upgrade.STRENGHT
	current_price = current_price_strength
	start_timer()

func _on_buy_button_strength_button_up() -> void:
	stop_timer()
	choice_price = 0

func _on_buy_button_mitigation_button_down() -> void:
	if Global.run_stats.player_stats[Stats.List.MITIGATION_PERCENT] >= 70:
		return
	buy_btn = buy_button_mitigation
	upgrade_type = Upgrade.MITIGATION
	current_price = current_price_mitigation
	start_timer()

func _on_buy_button_mitigation_button_up() -> void:
	stop_timer()
	choice_price = 0

func _on_buy_button_mitigation_mouse_entered() -> void:
	if Global.run_stats.player_stats[Stats.List.MITIGATION_PERCENT] >= 70:
		return
	upgrade_value_mitigation.text = ('+%.1f' % mitigation_increase).trim_suffix('.0')+'%'
	upgrade_value_mitigation.show()
	add_space(true)

func _on_buy_button_mitigation_mouse_exited() -> void:
	if Global.run_stats.player_stats[Stats.List.MITIGATION_PERCENT] >= 70:
		if upgrade_value_mitigation.is_visible_in_tree():
			upgrade_value_mitigation.hide()
			add_space(false)
		return
	upgrade_value_mitigation.hide()
	add_space(false)

func add_space(positive: bool) -> void:
	var child = find_child('Arraibmag')
	if child && !positive:
		child.get_child(1).custom_minimum_size.x -= 22
		child.get_child(1).custom_maximum_size.x -= 22
	if child && positive:
		child.get_child(1).custom_minimum_size.x += 22
		child.get_child(1).custom_maximum_size.x += 22

func _on_buy_button_strength_mouse_entered() -> void:
	var aux = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD]
	var strength = Global.run_stats.player_stats[Stats.List.SHIELD_STRENGTH]
	var labels = current_values_container.get_children()
	var count = Global.run_stats.player_stats[Stats.List.MAX_SHIELD_COUNT]
	
	for i in range(count):
		labels[i].show()
		if i < count-1:
			labels[i].text = '%d/[color=white]%d[/color]' % [strength, strength+1]
			aux -= strength
		else:
			labels[i].text = '%d/[color=white]%d[/color]' % [aux, strength+1] 

func _on_buy_button_strength_mouse_exited() -> void:
	update_value()
