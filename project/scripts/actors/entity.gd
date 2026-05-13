class_name Entity
extends Node2D

@export var is_passable: bool = false
@export var is_interactable: bool = false
@export var entity_name: String = ""

var cell: Vector2i

func _ready() -> void:
	cell = world_to_cell(position)
	WorldGrid.register(self, cell)

func _exit_tree() -> void:
	WorldGrid.unregister(cell)

func interact(source: Entity) -> void:
	pass

func take_turn() -> void:
	pass

func move_to(to_cell: Vector2i) -> void:
	WorldGrid.move_entity(self, cell, to_cell)
	cell = to_cell
	position = cell_to_world(cell)

func world_to_cell(world_pos: Vector2) -> Vector2i:
	return Vector2i(world_pos / Constants.Tile_Size)

func cell_to_world(cell: Vector2i) -> Vector2:
	return Vector2(cell * Constants.TILE_SIZE)
