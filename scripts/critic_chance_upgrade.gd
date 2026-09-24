extends StatUpgrade

func upgrade() -> void:
	withdraw_money()
	Global.run_stats.player_stats[stat] += amount_per_upgrade
	upgrades += 1
	update_price()
	update_value()

func _on_buy_button_button_up() -> void:
	upgrade()

func update_value() -> void:
	current_value.text = '%01f' %(Global.run_stats.player_stats[stat] + Global.modifier_manager.extra_stats[stat]) + '%'
