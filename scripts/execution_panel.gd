extends PanelContainer

@onready var progress_shader: PanelContainer = $MarginContainer/VBoxContainer/BtnsGroup/VBoxContainer/ProgressShader
@onready var execution_label_1: RichTextLabel = $MarginContainer/VBoxContainer/LightsGroup/VBoxContainer/ExecutionContainer1/PanelContainer/ExecutionLabel1
@onready var execution_label_2: RichTextLabel = $MarginContainer/VBoxContainer/LightsGroup/VBoxContainer/ExecutionContainer2/PanelContainer/ExecutionLabel2
@onready var execution_label_3: RichTextLabel = $MarginContainer/VBoxContainer/LightsGroup/VBoxContainer/ExecutionContainer3/PanelContainer/ExecutionLabel3
@onready var run_btn: Button = $MarginContainer/VBoxContainer/BtnsGroup/VBoxContainer/ProgressShader/RunBtn
@onready var execution_labels: Array[RichTextLabel] = [execution_label_1, execution_label_2, execution_label_3]
##How much the "Run" btn must be held to submit
@export_custom(PROPERTY_HINT_NONE, "suffix: s") var hold_run_duration: float = 2.0
var timer: float = 0.0
var holding_run: bool = false

func _ready() -> void:
	EventBus.turn_started.connect(start_turn)
	EventBus.submit_circuit.connect(lock_submit)

func _process(delta: float) -> void:
	if timer > 0:
		timer -= delta
		progress_shader.material.set_shader_parameter("progress", 1 - timer/hold_run_duration)
	if holding_run && timer <= 0:
		stop_timer()
		submit()

func submit() -> void:
	EventBus.submit_circuit.emit()
	EventBus.pulse.emit(0)
	await get_tree().create_timer(4).timeout
	EventBus.pulse.emit(1)
	await get_tree().create_timer(4).timeout
	EventBus.pulse.emit(2)

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
	timer = hold_run_duration
	holding_run = true

func stop_timer() -> void:
	timer = 0.0
	holding_run = false
	var shader = progress_shader.material as ShaderMaterial
	#var tween = create_tween()
	#tween.tween_property(shader, "shader_parameter/progress", 0, 1.0)
	#progress_shader.material.set_shader_parameter("progress", 1)

func lock_submit() -> void:
	run_btn.disabled = true

func unlock_submit() -> void:
	run_btn.disabled = false

func _on_run_btn_button_down() -> void:
	if Global.circuit_editor.sandbox.check_submit_requirements():
		start_timer()

func _on_run_btn_button_up() -> void:
	stop_timer()

func _on_pause_btn_button_up() -> void:
	Global.pause_game(true)
