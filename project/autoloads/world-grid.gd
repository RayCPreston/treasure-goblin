extends Node

var _cells: Dictionary = {}

func register(entity: Node2D, cell: Vector2i) -> void:
	_cells[cell] = entity

func unregister(cell: Vector2i) -> void:
	_cells.erase(cell)

func get_entity_at_cell(cell: Vector2i) -> Node2D:
	return _cells.get(cell, null)

func is_occupied(cell: Vector2i) -> bool:
	return _cells.has(cell)

func move_entity(entity: Node2D, from_cell: Vector2i, to_cell: Vector2i) -> void:
	unregister(from_cell)
	register(entity, to_cell)
