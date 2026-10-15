extends Control

#@onready var texture_rect: TextureRect = $TextureRect
@onready var texture_rect: TextureRect = $CanvasGroup/TextureRect

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

var type: Enemy.Type

var stats: Dictionary[Stats.List, Variant] = {
	Stats.List.MAX_HEALTH: 0,
	Stats.List.CURRENT_HEALTH: 0,
	Stats.List.BASE_HEAL: 0,
	Stats.List.MAX_SHIELD: 0,
	Stats.List.CURRENT_SHIELD: 0,
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
@export var outline_tween_duration: float = 0.05

func _ready() -> void:
	texture_rect.material = texture_rect.material.duplicate()
	set_stats()
	connect_signals()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		move(global_position+Vector2(500,0))

func is_the_signal_for_me(target: Node) -> bool:
	return target == self

##Undone
func take_damage(value: float, target: Node = null) -> void:
	print('take_damage ENEMY')
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

func heal() -> void:
	stats[Stats.List.CURRENT_HEALTH] += stats[Stats.List.BASE_HEAL]

func repair_shield(amount: float) -> void:
	stats[Stats.List.CURRENT_SHIELD] += int(amount)

func attack(amount: float) -> void:
	EventBus.damage_taken.emit(amount)

func set_stats() -> void:
	stats[Stats.List.MAX_HEALTH] = config.health
	stats[Stats.List.CURRENT_HEALTH] = config.health
	stats[Stats.List.BASE_HEAL] = base_heal
	stats[Stats.List.MAX_SHIELD] = config.shield
	stats[Stats.List.CURRENT_SHIELD] = config.shield
	stats[Stats.List.BASE_ATTACK_DAMAGE] = base_attack_damage
	stats[Stats.List.CRITIC_CHANCE] = critic_chance
	stats[Stats.List.CRITIC_MULTIPLIER] = critic_mult
	stats[Stats.List.MITIGATION_PERCENT] = mitigation_percent
	stats[Stats.List.CURRENT_ELEMENTALS] = current_elemental
	stats[Stats.List.CURRENT_AFFLICTED_ELEMENT] = null
	
	texture_rect.texture = config.texture

func connect_signals() -> void:
	#EventBus.attacked.connect(take_damage)
	pass

func link_to_status_bar() -> void:
	var parent = get_parent()
	for child in parent.get_children():
		if child != self:
			child.enemy = self
			status_bar = child

func update():
	pass

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

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			swap()
			print('pos: ', global_position)
			print('name: ', config._name)

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
