extends PanelContainer

@onready var attack: VBoxContainer = $MarginContainer/HBoxContainer/Attack
@onready var heal: VBoxContainer = $MarginContainer/HBoxContainer/Heal
@onready var shield_regen: VBoxContainer = $MarginContainer/HBoxContainer/ShieldRegen
@onready var self_damage: VBoxContainer = $MarginContainer/HBoxContainer/SelfDamage
@onready var charge_heavy_attack: VBoxContainer = $MarginContainer/HBoxContainer/ChargeHeavyAttack
@onready var heavy_attack: VBoxContainer = $MarginContainer/HBoxContainer/HeavyAttack

func set_attack(value: int) -> void:
	attack.get_child(1).text = '%04d' % value

func set_heal(value: int) -> void:
	heal.get_child(1).text = '%04d' % value

func set_shield_regen(value: int) -> void:
	shield_regen.get_child(1).text = '%04d' % value

func set_self_damage(value: int) -> void:
	self_damage.get_child(1).text = '%04d' % value

func set_charge_heavy_attack(value: int) -> void:
	charge_heavy_attack.get_child(1).text = '%04d' % value

func set_heavy_attack(value: int) -> void:
	heavy_attack.get_child(1).text = '%04d' % value
