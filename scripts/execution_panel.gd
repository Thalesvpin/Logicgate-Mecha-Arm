extends PanelContainer

@onready var progress_shader: PanelContainer = $MarginContainer/VBoxContainer/BtnsGroup/VBoxContainer/ProgressShader
@onready var execution_label_1: RichTextLabel = $MarginContainer/VBoxContainer/LightsGroup/VBoxContainer/ExecutionContainer1/PanelContainer/ExecutionLabel1
@onready var execution_label_2: RichTextLabel = $MarginContainer/VBoxContainer/LightsGroup/VBoxContainer/ExecutionContainer2/PanelContainer/ExecutionLabel2
@onready var execution_label_3: RichTextLabel = $MarginContainer/VBoxContainer/LightsGroup/VBoxContainer/ExecutionContainer3/PanelContainer/ExecutionLabel3
@onready var run_btn: Button = $MarginContainer/VBoxContainer/BtnsGroup/VBoxContainer/ProgressShader/RunBtn
@onready var execution_labels: Array[RichTextLabel] = [execution_label_1, execution_label_2, execution_label_3]
@onready var light_1: Control = $MarginContainer/VBoxContainer/LightsGroup/VBoxContainer/ExecutionContainer1/Light1
@onready var light_2: Control = $MarginContainer/VBoxContainer/LightsGroup/VBoxContainer/ExecutionContainer2/Light2
@onready var light_3: Control = $MarginContainer/VBoxContainer/LightsGroup/VBoxContainer/ExecutionContainer3/Light3
##How much the "Run" btn must be held to submit
@export_custom(PROPERTY_HINT_NONE, "suffix: s") var hold_run_duration: float = 2.0
var timer: float = 0.0
var holding_run: bool = false

func _ready() -> void:
	EventBus.turn_started.connect(start_turn)
	EventBus.submit_circuit.connect(lock_submit)

func _process(delta: float) -> void:
	if holding_run && timer < hold_run_duration:
		timer += delta
	elif holding_run && timer >= hold_run_duration:
		stop_timer()
		submit()
	elif timer > 0:
		timer -= delta
	progress_shader.material.set_shader_parameter("progress", timer/hold_run_duration)

func submit() -> void:
	print('submit')
	EventBus.submit_circuit.emit()
	turn_on_light(0)
	EventBus.pulse.emit(0)
	await get_tree().create_timer(4).timeout
	turn_on_light(1)
	EventBus.pulse.emit(1)
	await get_tree().create_timer(4).timeout
	turn_on_light(2)
	EventBus.pulse.emit(2)
	await get_tree().create_timer(2).timeout
	turn_on_light(-1)

func generate_execution_sequence() -> void:
	var list = Global.unique_random_list(execution_labels.size(), 4)
	Global.circuit_editor.execution_sequence = list
	
	for i in execution_labels.size():
		execution_labels[i].text = '%04d' % Global.dec_to_bin(list[i])

func start_turn(who) -> void:
	if typeof(who) == typeof('') && who == 'player':
		unlock_submit()
		generate_execution_sequence()

##Duration in seconds
func start_timer() -> void:
	holding_run = true

func stop_timer() -> void:
	if holding_run:
		timer = 0.0
	var shader = progress_shader.material as ShaderMaterial
	#var tween = create_tween()
	#tween.tween_property(shader, "shader_parameter/progress", 0, 1.0)
	#progress_shader.material.set_shader_parameter("progress", 1)

func lock_submit() -> void:
	run_btn.disabled = true

func unlock_submit() -> void:
	run_btn.disabled = false

func turn_on_light(idx: int) -> void:
	light_1.find_child('LightOff').show()
	light_2.find_child('LightOff').show()
	light_3.find_child('LightOff').show()
	light_1.find_child('LightOn').hide()
	light_2.find_child('LightOn').hide()
	light_3.find_child('LightOn').hide()
	match idx:
		0:
			light_1.find_child('LightOn').show()
			light_1.find_child('LightOff').hide()
		1:
			light_2.find_child('LightOn').show()
			light_2.find_child('LightOff').hide()
		2:
			light_3.find_child('LightOn').show()
			light_3.find_child('LightOff').hide()
		-1:
			pass

func _on_run_btn_button_down() -> void:
	if Global.circuit_editor.sandbox.check_submit_requirements():
		start_timer()

func _on_run_btn_button_up() -> void:
	holding_run = false
	stop_timer()

func _on_pause_btn_button_up() -> void:
	Global.pause_game(true)
