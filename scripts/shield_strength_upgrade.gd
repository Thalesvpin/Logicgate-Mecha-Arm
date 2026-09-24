extends StatUpgrade

@onready var mitigation_value_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/MitigationValueLabel
@onready var current_values_container: HBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer

@export var mitigation_increase: float:
	set(value):
		mitigation_increase = value/100

func upgrade() -> void:
	withdraw_money()
	Global.run_stats.player_stats[stat] += amount_per_upgrade
	Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD] = amount_per_upgrade * Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD_COUNT]
	Global.run_stats.player_stats[Stats.List.MITIGATION_PERCENT] += mitigation_increase
	
	upgrades += 1
	update_price()
	update_value()

func update_value() -> void:
	var aux = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD]
	var max = Global.run_stats.player_stats[Stats.List.MAX_SHIELD]
	var labels = current_values_container.get_children()
	var count = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD_COUNT]
	
	for i in range(count):
		labels[i].show()
		if i < count-1:
			labels[i].text = str(max)+'/'+str(max)
			aux -= max
		else:
			labels[i].text = str(aux) 
	
	mitigation_value_label.text = '-'+str(Global.run_stats.player_stats[Stats.List.MITIGATION_PERCENT] + Global.modifier_manager.extra_stats[Stats.List.MITIGATION_PERCENT])

func _on_buy_button_button_up() -> void:
	upgrade()
