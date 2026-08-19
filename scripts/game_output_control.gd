extends Control

@onready var area_2d: Area2D = $Area2D

var output: bool = false

func disconnect_wire(wire: Node2D):
	area_2d.connected_wires.erase(wire)
