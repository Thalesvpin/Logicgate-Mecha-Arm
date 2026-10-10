extends StatUpgrade

@onready var implant_value: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/ImplantValue
@onready var total_value: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/TotalValue
@onready var label: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Label
@onready var label_2: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Label2

func upgrade() -> void:
	withdraw_money()
	Global.run_stats.player_stats[stat] += amount_per_upgrade
	upgrades += 1
	update_price()
	update_value()

func update_value() -> void:
	if Global.implant_manager.extra_stats[stat] > 0:
		current_value.show()
		implant_value.show()
		label.show()
		label_2.show()
		current_value.text = str(Global.run_stats.player_stats[stat])
		implant_value.text = str(Global.modifier_manager.extra_stats[stat])
	else:
		current_value.hide()
		implant_value.hide()
		label.hide()
		label_2.hide()
	total_value.text = str(Global.run_stats.player_stats[stat]+Global.implant_manager.extra_stats[stat])

func _on_buy_button_button_down() -> void:
	start_timer()

func _on_buy_button_button_up() -> void:
	stop_timer()
