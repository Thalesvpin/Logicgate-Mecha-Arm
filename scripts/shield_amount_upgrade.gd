extends StatUpgrade

func upgrade() -> void:
	withdraw_money()
	Global.run_stats.player_stats[stat] += amount_per_upgrade
	Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD] += Global.run_stats.player_stats[Stats.List.MAX_SHIELD]
	upgrades += 1
	update_price()
	update_value()

func update_value() -> void:
	var curr = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD_COUNT]
	var max = Global.run_stats.player_stats[stat]
	current_value.text = str(curr)+' / '+str(max)+' '+char(0x25A0)+char(0x25A0)+char(0x25A1)

func _on_buy_button_button_down() -> void:
	start_timer()

func _on_buy_button_button_up() -> void:
	stop_timer()
