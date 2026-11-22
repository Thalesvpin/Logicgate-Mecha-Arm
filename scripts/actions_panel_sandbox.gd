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

func _ready() -> void:
	Global.actions_panel_sandbox = self

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

func light_up_attack() -> void:
	attack.find_child('BinaryOn').show()
	attack.find_child('BinaryOff').hide()
	await get_tree().create_timer(Global.action_duration).timeout
	attack.find_child('BinaryOff').show()
	attack.find_child('BinaryOn').hide()
		
func light_up_heal() -> void:
	heal.find_child('BinaryOn').show()
	heal.find_child('BinaryOff').hide()
	await get_tree().create_timer(Global.action_duration).timeout
	heal.find_child('BinaryOff').show()
	heal.find_child('BinaryOn').hide()
		
func light_up_shield_regen() -> void:
	shield_regen.find_child('BinaryOn').show()
	shield_regen.find_child('BinaryOff').hide()
	await get_tree().create_timer(Global.action_duration).timeout
	shield_regen.find_child('BinaryOff').show()
	shield_regen.find_child('BinaryOn').hide()
		
func light_up_self_damage() -> void:
	self_damage.find_child('BinaryOn').show()
	self_damage.find_child('BinaryOff').hide()
	await get_tree().create_timer(Global.action_duration).timeout
	self_damage.find_child('BinaryOff').show()
	self_damage.find_child('BinaryOn').hide()
		
func light_up_charge_heavy_attack() -> void:
	charge_heavy_attack.find_child('BinaryOn').show()
	charge_heavy_attack.find_child('BinaryOff').hide()
	await get_tree().create_timer(Global.action_duration).timeout
	charge_heavy_attack.find_child('BinaryOff').show()
	charge_heavy_attack.find_child('BinaryOn').hide()
		
func light_up_heavy_attack() -> void:
	heavy_attack.find_child('BinaryOn').show()
	heavy_attack.find_child('BinaryOff').hide()
	await get_tree().create_timer(Global.action_duration).timeout
	heavy_attack.find_child('BinaryOff').show()
	heavy_attack.find_child('BinaryOn').hide()
		
