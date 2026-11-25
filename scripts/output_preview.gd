extends PanelContainer

@onready var execution_label_1: RichTextLabel = $VBoxContainer/ExecutionContainer1/PanelContainer/ExecutionLabel1
@onready var execution_label_2: RichTextLabel = $VBoxContainer/ExecutionContainer2/PanelContainer/ExecutionLabel2
@onready var execution_label_3: RichTextLabel = $VBoxContainer/ExecutionContainer3/PanelContainer/ExecutionLabel3

var labels: Array
var cursor_offset: Vector2
var last_position: Vector2
var was_pressed := false
func _ready() -> void:
	labels = [execution_label_1, execution_label_2, execution_label_3]
	last_position = position

func _process(delta: float) -> void:
	handle_drag()
	if Global.circuit_editor.sandbox.check_submit_requirements():
		update()
	else:
		for label in labels:
			label.text = '- - - -'

func update() -> void:
	#var execution_sequence = Global.circuit_editor.execution_sequence
	var precalculated: Array = Global.circuit_editor.sandbox.game_output_manager.precalculate_output()
	var precalculated_bin: Array = []
	print('output preview: %d - %d - %d' % [precalculated[0], precalculated[1], precalculated[2]])
	for i in range(precalculated.size()):
		precalculated_bin.append(Global.dec_to_bin(precalculated[i]))
	for i in range(precalculated_bin.size()):
		#labels[i] = '%04d' % precalculated_bin[i]
		labels[i].text = '%04d' % precalculated_bin[i]

func _get_offset() -> void:
	cursor_offset = get_global_mouse_position() - global_position

func handle_drag() -> void:
	if DragManager.am_i_dragged(self):
		global_position = get_global_mouse_position() - cursor_offset
		var is_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
		if was_pressed && !is_pressed:
			DragManager.drop_output_preview()
			last_position = position
		was_pressed = is_pressed

func _on_drag_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			print('asglhavkajsfçasj')
			DragManager.drag_output_preview(self)
			_get_offset()
