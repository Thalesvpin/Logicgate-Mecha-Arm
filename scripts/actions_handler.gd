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
	EventBus.heavy_attack_used.connect(charged_attack)
	EventBus.charged_heavy_attack.connect(charge_attack)
	EventBus.self_damage.connect(self_dmg)
	EventBus.healed.connect(heal)
	EventBus.repaired_shield.connect(repair_shield)

func attack() -> void:
	var effect = DealDamageEffect.new()
	effect.amount = 0
	effect.apply()
	pass

func charged_attack() -> void:
	print('Charged Attack')
	var effect = HeavyAttackEffect.new()
	effect.apply()

func charge_attack() -> void:
	print('Attack Charged')
	var effect = ChargeHeavyAttackEffect.new()
	effect.apply()

func self_dmg(value) -> void:
	print('Self Damage')
	var effect = SelfDamageEffect.new()
	effect.amount = Global.run_stats.player_stats.self_damage
	effect.apply()

func heal() -> void:
	print('Heal')
	var effect = HealEffect.new()
	effect.amount = 10
	effect.apply()

func repair_shield() -> void:
	var effect = RepairShieldEffect.new()
	effect.apply()
	pass

func take_damage(value) -> void:
	print('Take Damage')
	var effect = TakeDamageEffect.new()
	effect.amount = value
	effect.apply()
