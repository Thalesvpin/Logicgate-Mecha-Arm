extends Control
@onready var sandbox_action_panel: PanelContainer = $VBoxContainer/VSplitContainer/baixo/HSplitContainer/HBoxContainer/SandboxActionPanel
@onready var circuit_editor: PanelContainer = $VBoxContainer/VSplitContainer/baixo/HSplitContainer/HBoxContainer/CircuitEditor
@onready var combat_screen: PanelContainer = $VBoxContainer/VSplitContainer/cima/HSplitContainer/CombatScreen

func _ready() -> void:
	if Global.seed == 0:
		Global.set_new_seed()
	randomize_binaries()
	connect_action_signals()

func randomize_binaries() -> void:
	sandbox_action_panel.generate_execution_sequence()
	circuit_editor.generate_action_list()

func connect_action_signals() -> void:
	combat_screen.connect_action_signals(circuit_editor)
