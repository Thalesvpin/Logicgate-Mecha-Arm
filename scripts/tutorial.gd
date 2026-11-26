extends Control

@onready var circuit_editor: PanelContainer = $CircuitEditor
@onready var gate_logic_label: RichTextLabel = $GateLogicPanel/GateLogicLabel
@onready var connection_instruction_label: RichTextLabel = $ObjectivePanel/ConnectionInstructionLabel
@onready var objective_label: RichTextLabel = $ObjectivePanel/ObjectiveLabel
var current_step: int = 0
var steps_explanation: Dictionary[int, String] = {
	0: 'Esta é uma porta do tipo AND. Ela entrega saída 1 somente quando todas as suas entradas são 1. Se qualquer entrada for 0, a saída será 0.',
	1: 'Esta é uma porta do tipo OR. Ela entrega saída 1 quando pelo menos uma de suas entradas é 1. Ela só produz 0 quando todas as entradas são 0.',
	2: 'Esta é uma porta do tipo XOR. Ela entrega saída 1 apenas quando somente uma de suas entradas é 1. Se nenhuma ou mais de uma entrada forem 1, a saída será 0',
	3: 'Esta é uma porta do tipo NOT. Ela possui uma única entrada e simplesmente inverte seu valor: 0 vira 1 e 1 vira 0. É a porta mais simples e serve para negar um sinal lógico.',
	
}
var objective_texts: Dictionary[int, String] = {
	0: 'Faça o output ser 1 para seguir',
	1: '',
	2: '',
	3: '',
}

func _ready() -> void:
	circuit_editor.lock_zoom(true)
	gate_logic_label.text = steps_explanation[current_step]
	objective_label.text = objective_texts[current_step]

func next_step() -> void:
	current_step += 1
	gate_logic_label.text = steps_explanation[current_step]
