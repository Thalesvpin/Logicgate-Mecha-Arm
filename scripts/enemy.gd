extends Control

#@onready var texture_rect: TextureRect = $TextureRect
@onready var texture_rect: TextureRect = $CanvasGroup/TextureRect
@onready var turn_indicator: TextureRect = $TurnIndicator

@export var config: EnemyConfig
var max_heatlh: int
var base_heal: float
var max_shield: int
var base_attack_damage: int
var critic_chance: float
var critic_mult: float
var mitigation_percent: float
var current_elemental: Variant
@export var movement_tween_duration: float = 0.8
##Applied as the turn begins
@export var turn_start_delay: float = 2
##Applied after an action is executed. Does not wait for the action animation to begin!
@export var between_actions_delay: float = 2
var type: Enemy.Type

var stats: Dictionary[Stats.List, Variant] = {
	Stats.List.MAX_HEALTH: 0,
	Stats.List.CURRENT_HEALTH: 0,
	Stats.List.BASE_HEAL: 0,
	Stats.List.MAX_SHIELD: 0,
	Stats.List.CURRENT_SHIELD: 0,
	Stats.List.BASE_SHIELD_REPAIR: 0,
	Stats.List.BASE_ATTACK_DAMAGE: 0,
	Stats.List.CRITIC_CHANCE: 0,
	Stats.List.CRITIC_MULTIPLIER: 0,
	Stats.List.MITIGATION_PERCENT: 0,
	Stats.List.CURRENT_ELEMENTALS: null,
	Stats.List.CURRENT_AFFLICTED_ELEMENT: null
}

var id
var enemy_name: String
var battle_position
var status_bar
var _position
var actions_list: Array
var actions_weight: Array
@export var outline_tween_duration: float = 0.05

func _ready() -> void:
	texture_rect.material = texture_rect.material.duplicate()
	set_stats()
	connect_signals()

##Undone
func take_damage(value: float, target: Node = null) -> void:
	print('take_damage ENEMY')
	shake_anim()
	#if !is_the_signal_for_me(target):
		#return
	
	var final_taken_dmg := 0
	if stats[Stats.List.CURRENT_SHIELD] > 0:
		#mitigation
		stats[Stats.List.CURRENT_SHIELD] -= 10
		final_taken_dmg = int(value*mitigation_percent)
		final_taken_dmg = 2
		pass
	else:
		final_taken_dmg = int(value)
	
	if stats[Stats.List.CURRENT_HEALTH] - final_taken_dmg >= 0:
		stats[Stats.List.CURRENT_HEALTH] -= final_taken_dmg
	else:
		stats[Stats.List.CURRENT_HEALTH] = 0
	status_bar.update(true)
	
	if stats[Stats.List.CURRENT_HEALTH] == 0:
		print('ENEMY signal defeat')
		EventBus.enemy_defeated.emit(self)

func self_damage() -> void:
	pass

func heal() -> void:
	stats[Stats.List.CURRENT_HEALTH] += stats[Stats.List.BASE_HEAL]

func repair_shield() -> void:
	stats[Stats.List.CURRENT_SHIELD] += int()

func attack() -> void:
	shake_anim()
	EventBus.damage_taken.emit(stats[Stats.List.BASE_ATTACK_DAMAGE])

func set_stats() -> void:
	if config.is_boss:
		stats[Stats.List.MAX_HEALTH] = Enemy.status_boss[Stats.List.MAX_HEALTH]
		stats[Stats.List.CURRENT_HEALTH] = stats[Stats.List.MAX_HEALTH]
		stats[Stats.List.BASE_HEAL] = Enemy.status_boss[Stats.List.BASE_HEAL]
		stats[Stats.List.MAX_SHIELD] = Enemy.status_boss[Stats.List.MAX_SHIELD]
		stats[Stats.List.CURRENT_SHIELD] = stats[Stats.List.MAX_SHIELD]
		stats[Stats.List.BASE_SHIELD_REPAIR] = Enemy.status_boss[Stats.List.BASE_SHIELD_REPAIR]
		stats[Stats.List.BASE_ATTACK_DAMAGE] = Enemy.status_boss[Stats.List.BASE_ATTACK_DAMAGE]
		stats[Stats.List.CRITIC_CHANCE] = 0
		stats[Stats.List.CRITIC_MULTIPLIER] = 0
		stats[Stats.List.MITIGATION_PERCENT] = Enemy.status_boss[Stats.List.MITIGATION_PERCENT]
		stats[Stats.List.CURRENT_ELEMENTALS] = null
		stats[Stats.List.CURRENT_AFFLICTED_ELEMENT] = null
	else:
		stats[Stats.List.MAX_HEALTH] = Enemy.status_preset[config.status_preset][Stats.List.MAX_HEALTH]
		stats[Stats.List.CURRENT_HEALTH] = stats[Stats.List.MAX_HEALTH]
		stats[Stats.List.BASE_HEAL] = Enemy.status_preset[config.status_preset][Stats.List.BASE_HEAL]
		stats[Stats.List.MAX_SHIELD] = Enemy.status_preset[config.status_preset][Stats.List.MAX_SHIELD]
		stats[Stats.List.CURRENT_SHIELD] = stats[Stats.List.MAX_SHIELD]
		stats[Stats.List.BASE_SHIELD_REPAIR] = Enemy.status_preset[config.status_preset][Stats.List.BASE_SHIELD_REPAIR]
		stats[Stats.List.BASE_ATTACK_DAMAGE] = Enemy.status_preset[config.status_preset][Stats.List.BASE_ATTACK_DAMAGE]
		stats[Stats.List.CRITIC_CHANCE] = 0
		stats[Stats.List.CRITIC_MULTIPLIER] = 0
		stats[Stats.List.MITIGATION_PERCENT] = Enemy.status_preset[config.status_preset][Stats.List.MITIGATION_PERCENT]
		stats[Stats.List.CURRENT_ELEMENTALS] = null
		stats[Stats.List.CURRENT_AFFLICTED_ELEMENT] = null
	
	texture_rect.texture = config.texture
	actions_list = config.actions_list
	actions_weight = config.actions_weight

func connect_signals() -> void:
	EventBus.turn_started.connect(turn_start)
	#EventBus.attacked.connect(take_damage)
	pass

func link_to_status_bar() -> void:
	var parent = get_parent()
	for child in parent.get_children():
		if child != self:
			child.enemy = self
			status_bar = child

func turn_start(who):
	print(who, '   -    ', config._name)
	if typeof(who) == typeof(Object) && who == self:
		turn_indicator.show()
		await get_tree().create_timer(turn_start_delay).timeout
		var action
		for i in range(config.actions_per_turn):
			action = actions_list[random_action()]
			match action:
				Enemy.Actions.ATTACK:
					print('enemy attack')
					attack()
				Enemy.Actions.SELF_DAMAGE:
					self_damage()
				Enemy.Actions.HEAL:
					heal()
				Enemy.Actions.REPAIR_SHIELD:
					print('enemy repair shield')
					repair_shield()
			await get_tree().create_timer(between_actions_delay).timeout
		turn_indicator.hide()
		EventBus.turn_ended.emit(self)

func random_action() -> int:
	var rng = Global.random.next() % 100
	var sum := 0.0
	
	for i in range(actions_weight.size()):
		sum += actions_weight[i]
		if rng < sum:
			return i
	return actions_weight.size()

func move(dest: Vector2) -> void:
	offset_transform_enabled = true
	print('antes g_p: ', global_position)
	offset_transform_position = dest - global_position
	print('aqui no meio: ', global_position,'\t ', config._name, '\tdest: ', dest)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, 'offset_transform_position', Vector2.ZERO, movement_tween_duration)
	tween.tween_callback(
		func():
			offset_transform_position = Vector2.ZERO
			offset_transform_enabled = false
			get_parent().owner.block_movement = false
	)

func shake_anim() -> void:
	var tween = create_tween()
	tween.tween_property(texture_rect, 'offset_transform_position', Vector2(0, 20), 0.05)
	tween.chain().tween_property(texture_rect, 'offset_transform_position', Vector2(0, -20), 0.1)
	tween.chain().tween_property(texture_rect, 'offset_transform_position', Vector2(0, 0), 0.05)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			swap()

func swap():
	if _position != EnemyPosition.Position.CENTER && stats[Stats.List.CURRENT_HEALTH] > 0:
		get_parent().owner.center_enemy(self)

func _on_mouse_entered() -> void:
	var shader := texture_rect.material as ShaderMaterial
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(shader, "shader_parameter/outline_width", 0.005, outline_tween_duration)

func _on_mouse_exited() -> void:
	var shader := texture_rect.material as ShaderMaterial
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(shader, "shader_parameter/outline_width", 0.0, outline_tween_duration)
