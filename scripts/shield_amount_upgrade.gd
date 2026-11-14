extends StatUpgrade

func upgrade() -> void:
	if withdraw_money():
		#Global.run_stats.player_stats[stat] += amount_per_upgrade
		#Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD] += Global.run_stats.player_stats[Stats.List.MAX_SHIELD]
		var ef = AddMaxShieldCountEffect.new()
		ef.amount = amount_per_upgrade
		ef.apply()
		var ef2 = RepairShieldEffect.new()
		ef2.amount = Global.run_stats.player_stats[Stats.List.MAX_SHIELD]
		ef2.apply()
	
		upgrades += 1
		if upgrades >= 3:
			buy_btn.disabled = true
			price.text = '  MAX  '
		else:
			update_price()
		update_value()

func update_value() -> void:
	var curr = Global.run_stats.player_stats[Stats.List.MAX_SHIELD_COUNT]
	current_value.text = '%d / 3 ' % curr
	for i in range(curr):
		current_value.text += char(0x25A0)
	for i in range(3-curr):
		current_value.text += char(0x25A1)
		

func _on_buy_button_button_down() -> void:
	start_timer()

func _on_buy_button_button_up() -> void:
	stop_timer()
