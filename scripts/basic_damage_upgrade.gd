extends StatUpgrade

@onready var implant_value: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/ImplantValue
@onready var total_value: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/TotalValue
@onready var label: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Label
@onready var label_2: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Label2

func upgrade() -> void:
	if withdraw_money():
		#Global.run_stats.player_stats[stat] += amount_per_upgrade
		var ef = AddDamageFlatEffect.new()
		ef.amount = amount_per_upgrade
		ef.apply()
		upgrades_count += 1
		update_price()
		update_value()

func update_value() -> void:
	current_value.text = '%d' % Global.run_stats.player_stats[stat]
	current_value.show()

func _on_buy_button_button_down() -> void:
	start_timer()

func _on_buy_button_button_up() -> void:
	stop_timer()

func _on_buy_button_mouse_entered() -> void:
	print('amount interno: ', amount_per_upgrade)
	show_reward()

func _on_buy_button_mouse_exited() -> void:
	hide_reward()
