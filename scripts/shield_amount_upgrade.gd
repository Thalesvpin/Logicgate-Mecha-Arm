extends StatUpgrade

@onready var s_1: TextureRect = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/S1
@onready var s_2: TextureRect = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/S2
@onready var s_3: TextureRect = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/S3
@onready var s_4: TextureRect = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/S4
var units: Array[TextureRect]

func ready() -> void:
	units = [s_1, s_2, s_3, s_4]

func upgrade() -> void:
	if withdraw_money():
		#Global.run_stats.player_stats[stat] += amount_per_upgrade
		#Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD] += Global.run_stats.player_stats[Stats.List.MAX_SHIELD]
		var ef = AddMaxShieldCountEffect.new()
		ef.amount = amount_per_upgrade
		ef.apply()
		var ef2 = RepairShieldEffect.new()
		ef2.amount = Global.run_stats.player_stats[Stats.List.SHIELD_STRENGTH]
		ef2.apply()
	
		upgrades_count += 1
		if upgrades_count >= 3:
			buy_btn.disabled = true
			price.text = '  MAX  '
		else:
			update_price()
		update_value()
		get_parent().owner.show_action_repair_shield()
		EventBus.shield_count.emit()

func update_value() -> void:
	var curr = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD_COUNT]
	var _max = Global.run_stats.player_stats[Stats.List.MAX_SHIELD_COUNT]
	current_value.text = '%d / %d ' % [curr, _max]
	for u in units:
		u.hide()
	for i in range(_max):
		units[i].show()
		units[i].get_child(0).show()
	for i in range(curr):
		units[i].get_child(0).hide()

func _on_buy_button_button_down() -> void:
	start_timer()

func _on_buy_button_button_up() -> void:
	stop_timer()

func _on_buy_button_mouse_entered() -> void:
	var _max = Global.run_stats.player_stats[Stats.List.MAX_SHIELD_COUNT]
	if _max == 3:
		return
	var upgrd = units[_max+1]
	upgrd.show()
	var mat = upgrd.material as ShaderMaterial
	mat.set_shader_parameter('overlay_color', Color('white'))

func _on_buy_button_mouse_exited() -> void:
	var _max = Global.run_stats.player_stats[Stats.List.MAX_SHIELD_COUNT]
	if _max+1 < units.size():
		units[_max+1].hide()
	for u in range(units.size()-1):
		var mat = units[u].material as ShaderMaterial
		mat.set_shader_parameter('overlay_color', LivePalette.SHOP.BLUESTATS)
