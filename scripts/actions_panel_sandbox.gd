extends PanelContainer

@onready var attack: VBoxContainer = $MarginContainer/HBoxContainer/Attack
@onready var heal: VBoxContainer = $MarginContainer/HBoxContainer/Heal
@onready var shield_regen: VBoxContainer = $MarginContainer/HBoxContainer/ShieldRegen
@onready var self_damage: VBoxContainer = $MarginContainer/HBoxContainer/SelfDamage
@onready var charge_heavy_attack: VBoxContainer = $MarginContainer/HBoxContainer/ChargeHeavyAttack
@onready var heavy_attack: VBoxContainer = $MarginContainer/HBoxContainer/HeavyAttack
@onready var attack_label: RichTextLabel = $MarginContainer/HBoxContainer/Attack/PanelContainer/AttackLabel
@onready var heal_label: RichTextLabel = $MarginContainer/HBoxContainer/Heal/PanelContainer2/HealLabel
@onready var shield_regen_label: RichTextLabel = $MarginContainer/HBoxContainer/ShieldRegen/PanelContainer3/ShieldRegenLabel
@onready var self_damage_label: RichTextLabel = $MarginContainer/HBoxContainer/SelfDamage/PanelContainer4/SelfDamageLabel
@onready var charge_heavy_attack_label: RichTextLabel = $MarginContainer/HBoxContainer/ChargeHeavyAttack/PanelContainer5/ChargeHeavyAttackLabel
@onready var heavy_attack_label: RichTextLabel = $MarginContainer/HBoxContainer/HeavyAttack/PanelContainer6/HeavyAttackLabel

func set_attack(value: int) -> void:
	attack_label.text = '%04d' % value

func set_heal(value: int) -> void:
	heal_label.text = '%04d' % value

func set_shield_regen(value: int) -> void:
	shield_regen_label.text = '%04d' % value

func set_self_damage(value: int) -> void:
	self_damage_label.text = '%04d' % value

func set_charge_heavy_attack(value: int) -> void:
	charge_heavy_attack_label.text = '%04d' % value

func set_heavy_attack(value: int) -> void:
	heavy_attack_label.text = '%04d' % value
