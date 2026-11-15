extends StatUpgrade

@onready var mitigation_value_label: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/MitigationValueLabel
@onready var current_values_container: HBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer
@onready var shield_strength_price_label: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer3/VBoxContainer/ShieldStrengthPrice
@onready var mitigation_price_label: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer3/VBoxContainer/MitigationPrice

@export var mitigation_increase: float:
	set(value):
		mitigation_increase = value/100
var choice_price: int = 0

func upgrade() -> void:
	if withdraw_money():
		#Global.run_stats.player_stats[stat] += amount_per_upgrade
		#Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD] = amount_per_upgrade * Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD_COUNT]
		#Global.run_stats.player_stats[Stats.List.MITIGATION_PERCENT] += mitigation_increase
		var ef = AddShieldStrengthEffect.new()
		ef.amount = int(amount_per_upgrade)
		ef.apply()
		var ef2 = RepairShieldEffect.new()
		ef2.amount = int(amount_per_upgrade) * Global.run_stats.player_stats[Stats.List.MAX_SHIELD_COUNT]
		ef2.apply()
		var ef3 = AddMitigationPercentEffect.new()
		ef3.amount = mitigation_increase
		ef3.apply()
		
		
		upgrades += 1
		update_price()
		update_value()

func upgrade_mitigation() -> void:
	if withdraw_money():
		pass

func update_price() -> void:
	if upgrades < preset_prices.size():
		current_price = preset_prices[upgrades]
	else:
		if action_after_preset == PriceAction.ADD:
			current_price += after_preset_value
		if action_after_preset == PriceAction.MULTIPLY:
			current_price *= after_preset_value
	price.text = '$ %d' % current_price

func update_value() -> void:
	var aux = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD]
	var max = Global.run_stats.player_stats[Stats.List.MAX_SHIELD]
	var labels = current_values_container.get_children()
	var count = Global.run_stats.player_stats[Stats.List.MAX_SHIELD_COUNT]
	
	for i in range(count):
		labels[i].show()
		if i < count-1:
			labels[i].text = '%d/%d' %max %max
			aux -= max
		else:
			labels[i].text = str(aux) 
	
	mitigation_value_label.text = '-'+str(Global.run_stats.player_stats[Stats.List.MITIGATION_PERCENT] + Global.implant_manager.extra_stats[Stats.List.MITIGATION_PERCENT])

func withdraw_money() -> bool:
	if Global.run_stats.player_stats[Stats.List.CURRENT_MONEY] < choice_price:
		return false
	var ef = AddMoneyEffect.new()
	ef.amount = -current_price
	ef.apply()
	return true

func _on_buy_button_button_down() -> void:
	start_timer()

func _on_buy_button_button_up() -> void:
	stop_timer()


func _on_buy_button_mitigation_button_up() -> void:
	pass # Replace with function body.


func _on_buy_button_strength_button_up() -> void:
	pass # Replace with function body.
