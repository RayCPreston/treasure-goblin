class_name Level
extends Node2D

func _ready() -> void:
	WorldGrid.initialize([$"floor-layer", $"wall-layer"])
