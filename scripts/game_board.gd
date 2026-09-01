extends Control
@onready var sandbox_action_panel: PanelContainer = $VBoxContainer/VSplitContainer/baixo/HSplitContainer/HBoxContainer/SandboxActionPanel
@onready var circuit_editor: PanelContainer = $VBoxContainer/VSplitContainer/baixo/HSplitContainer/HBoxContainer/CircuitEditor
@onready var combat_screen: PanelContainer = $VBoxContainer/VSplitContainer/cima/HSplitContainer/CombatScreen
@onready var tech_mods_container: PanelContainer = $VBoxContainer/VSplitContainer/cima/HSplitContainer/TechModsContainer
@onready var bio_hacks_container: PanelContainer = $VBoxContainer/VSplitContainer/cima/HSplitContainer/BioHacksContainer

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




const TECHMOD_TEST = preload("uid://3gmr422layic")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test2"):# Y
		tech_mods_container.add_mod(TECHMOD_TEST)
	if event.is_action_pressed("test3"):# U
		#EventBus.damage_taken.emit(20)
		#EventBus.enemy_defeated.emit()
		EventBus.critical_hit.emit()
		print('crit emitido')
