extends Control
@onready var sandbox_action_panel: PanelContainer = $VBoxContainer/VSplitContainer/baixo/HSplitContainer/HBoxContainer/SandboxActionPanel
@onready var circuit_editor: PanelContainer = $VBoxContainer/VSplitContainer/baixo/HSplitContainer/HBoxContainer/CircuitEditor

func _ready() -> void:
	Global.set_new_seed()
	randomize_binaries()

func randomize_binaries() -> void:
	sandbox_action_panel.generate_execution_sequence()
	circuit_editor.generate_action_list()
