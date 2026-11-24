extends Node

@onready var run_stats: Node = $"../RunStats"

var selected_enemy = null
var right_enemy_container
var center_enemy_container
var left_enemy_container

func _ready() -> void:
	right_enemy_container = Global.combat_screen.right_enemy_container
	center_enemy_container = Global.combat_screen.center_enemy_container
	left_enemy_container = Global.combat_screen.left_enemy_container
	setup_signals()

func setup_signals() -> void:
	EventBus.attacked.connect(attack)
	EventBus.heavy_attack_used.connect(heavy_attack)
	EventBus.charged_heavy_attack.connect(charge_attack)
	EventBus.self_damage.connect(self_dmg)
	EventBus.healed.connect(heal)
	EventBus.repaired_shield.connect(repair_shield)
	EventBus.damage_taken.connect(take_damage)


func attack() -> void:
	print('Light Attack')
	Global.actions_panel_sandbox.light_up_attack()
	var effect = DealDamageEffect.new()
	effect.amount = 0
	effect.apply()
	pass

func heavy_attack() -> void:
	print('Heavy Attack')
	Global.actions_panel_sandbox.light_up_heavy_attack()
	var effect = HeavyAttackEffect.new()
	effect.apply()

func charge_attack() -> void:
	print('Heavy Attack Charged')
	Global.actions_panel_sandbox.light_up_charge_heavy_attack()
	var effect = ChargeHeavyAttackEffect.new()
	effect.apply()

func self_dmg(value: int = 0) -> void:
	print('Self Damage ')
	Global.actions_panel_sandbox.light_up_self_damage()
	var effect = SelfDamageEffect.new()
	if value == 0:
		effect.amount = Global.run_stats.player_stats[Stats.List.SELF_DAMAGE]
	else:
		
		effect.amount = value
	effect.apply()

func heal() -> void:
	print('Heal')
	Global.actions_panel_sandbox.light_up_heal()
	var effect = HealEffect.new()
	effect.amount = 0
	effect.apply()

func repair_shield() -> void:
	print('Repair Shield')
	Global.actions_panel_sandbox.light_up_shield_regen()
	var effect = RepairShieldEffect.new()
	effect.amount = Global.run_stats.player_stats[Stats.List.BASE_SHIELD_REPAIR]
	effect.apply()
	pass

func take_damage(context) -> void:
	print('Take Damage')
	
	var effect = TakeDamageEffect.new()
	effect.amount = context["damage"]
	effect.apply(context)
