extends StatUpgrade

func upgrade() -> void:
	if withdraw_money():
		#Global.run_stats.player_stats[stat] += amount_per_upgrade
		var ef = AddCritChancePercent.new()
		ef.amount = amount_per_upgrade
		ef.apply()
		upgrades_count += 1
		update_price()
		update_value()

func _on_buy_button_button_down() -> void:
	start_timer()

func _on_buy_button_button_up() -> void:
	stop_timer()

func update_value() -> void:
	current_value.text = ('%.1f' %(Global.run_stats.player_stats[stat] + Global.implant_manager.extra_stats[stat])).trim_suffix(".0") + '%'

func _on_buy_button_mouse_entered() -> void:
	show_reward('%')

func _on_buy_button_mouse_exited() -> void:
	hide_reward()
