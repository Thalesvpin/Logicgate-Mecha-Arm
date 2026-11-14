extends StatUpgrade

@onready var total_value: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/TotalValue
@onready var implant_value: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/ImplantValue
@onready var label: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Label
@onready var label_2: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Label2

# exemple
# 85/120 (100+20)

func upgrade() -> void:
	if withdraw_money():
		#Global.run_stats.player_stats[stat] += amount_per_upgrade
		var ef = AddMaxHealthFlatEffect.new()
		ef.amount = amount_per_upgrade
		ef.apply()
		var ef2 = HealEffect.new()
		ef2.amount = amount_per_upgrade
		ef2.apply()
		upgrades += 1
		update_price()
		update_value()

func _on_buy_button_button_down() -> void:
	start_timer()

func _on_buy_button_button_up() -> void:
	stop_timer()

func update_value() -> void:
	var curr = Global.run_stats.player_stats[Stats.List.CURRENT_HEALTH]
	var max = Global.run_stats.player_stats[stat] + Global.implant_manager.extra_stats[stat]
	if Global.implant_manager.extra_stats[stat] > 0:
		label.show()
		label_2.show()
		current_value.show()
		implant_value.show()
	else:
		label.hide()
		label_2.hide()
		current_value.hide()
		implant_value.hide()
	
	total_value.text = '%d / %d' % [curr, max]
	current_value.text = str(Global.run_stats.player_stats[stat])
	implant_value.text = '+'+str(Global.implant_manager.extra_stats[stat])
