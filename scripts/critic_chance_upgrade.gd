extends StatUpgrade

func upgrade() -> void:
	withdraw_money()
	Global.run_stats.player_stats[stat] += amount_per_upgrade
	upgrades += 1
	update_price()
	update_value()

func _on_buy_button_button_down() -> void:
	start_timer()

func _on_buy_button_button_up() -> void:
	stop_timer()

func update_value() -> void:
	pass
	#current_value.text = '%01f' %(Global.run_stats.player_stats[stat] + Global.implant_manager.extra_stats[stat]) + '%'
