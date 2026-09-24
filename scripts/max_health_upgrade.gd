extends StatUpgrade

@onready var total_value: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/TotalValue
@onready var implant_value: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/ImplantValue
@onready var label: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Label
@onready var label_2: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Label2

# exemple
# 85/120 (100+20)

func upgrade() -> void:
	withdraw_money()
	Global.run_stats.player_stats[stat] += amount_per_upgrade
	upgrades += 1
	update_price()
	

func _on_buy_button_button_up() -> void:
	upgrade()

func update_value() -> void:
	var curr = Global.run_stats.player_stats[Stats.List.CURRENT_HEALTH]
	var max = Global.run_stats.player_stats[stat] + Global.modifier_manager.extra_stats[stat]
	if Global.modifier_manager.extra_stats[stat] > 0:
		label.show()
		label_2.show()
		current_value.show()
		implant_value.show()
	else:
		label.hide()
		label_2.hide()
		current_value.hide()
		implant_value.hide()
	
	total_value.text = str(curr)+' / '+str(max)
	current_value.text = str(Global.run_stats.player_stats[stat])
	implant_value.text = '+'+str(Global.modifier_manager.extra_stats[stat])
