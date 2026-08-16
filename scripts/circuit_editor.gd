extends PanelContainer

@onready var gate_layer: Node2D = $SubViewportContainer/SubViewport/Sandbox/GateLayer
@onready var wire_layer: Node2D = $SubViewportContainer/SubViewport/Sandbox/WireLayer
@onready var drag_layer: Node2D = $SubViewportContainer/SubViewport/Sandbox/DragLayer
@onready var circuit_camera: Camera2D = $SubViewportContainer/SubViewport/Sandbox/CircuitCamera
@onready var sandbox: Node2D = $SubViewportContainer/SubViewport/Sandbox

func _ready() -> void:
	Global.circuit_editor = self
