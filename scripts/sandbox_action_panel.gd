extends PanelContainer

@onready var execution_label_1: Label = $MarginContainer/ScrollContainer/VBoxContainer/ExecutionContainer1/ExecutionLabel1
@onready var execution_label_2: Label = $MarginContainer/ScrollContainer/VBoxContainer/ExecutionContainer2/ExecutionLabel2
@onready var execution_label_3: Label = $MarginContainer/ScrollContainer/VBoxContainer/ExecutionContainer3/ExecutionLabel3
@onready var run_btn: TextureButton = $MarginContainer/ScrollContainer/VBoxContainer/RunBtn
@onready var execution_labels: Array[Label] = [execution_label_1, execution_label_2, execution_label_3]
##How much the "Run" btn must be held to submit
@export_custom(PROPERTY_HINT_NONE, "suffix: s") var hold_run_duration: float = 2.0
var timer: float = 0.0
var holding_run: bool = false

func _process(delta: float) -> void:
	if timer > 0:
		timer -= delta
		run_btn.material.set_shader_parameter("progress", 1 - timer/hold_run_duration)
	if holding_run && timer <= 0:
		stop_timer()
		submit()

func submit() -> void:
	#Global.output_manager.submit()
	EventBus.submit_circuit.emit()
	EventBus.pulse.emit(0)
	await get_tree().create_timer(4).timeout
	EventBus.pulse.emit(1)
	await get_tree().create_timer(4).timeout
	EventBus.pulse.emit(2)
	#get_tree().current_scene.randomize_binaries()

func generate_execution_sequence() -> void:
	var list = Global.unique_random_list(execution_labels.size(), 4)
	Global.circuit_editor.execution_sequence = list
	
	for i in execution_labels.size():
		execution_labels[i].text = '%04d' % Global.dec_to_bin(list[i])

##Duration in seconds
func start_timer() -> void:
	timer = hold_run_duration
	holding_run = true

func stop_timer() -> void:
	timer = 0.0
	holding_run = false
	run_btn.material.set_shader_parameter("progress", 1)

func _on_run_btn_button_down() -> void:
	start_timer()

func _on_run_btn_button_up() -> void:
	stop_timer()
