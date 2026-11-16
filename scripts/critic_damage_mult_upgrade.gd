extends StatUpgrade

func upgrade() -> void:
	if withdraw_money():
		var ef = AddCritDamagePercent.new()
		ef.amount = amount_per_upgrade
		ef.apply()
		
		upgrades_count += 1
		update_price()
		update_value()

func update_value() -> void:
	var value = Global.run_stats.player_stats[stat] + Global.implant_manager.extra_stats[stat]
	current_value.text = ('x%.1f' % value).trim_suffix(".0")

func _on_buy_button_button_down() -> void:
	start_timer()

func _on_buy_button_button_up() -> void:
	stop_timer()
