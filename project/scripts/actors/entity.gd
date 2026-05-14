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

func interact(_source: Entity) -> void:
	pass

func take_turn() -> void:
	pass

func try_move_to(to_cell: Vector2i) -> void:
	var occupant: Entity = WorldGrid.get_entity_at_cell(to_cell)
	if occupant and occupant.is_passable:
		swap_with(occupant)
	elif occupant and occupant.is_interactable:
		occupant.interact(self)
	elif WorldGrid.is_cell_available(to_cell):
		move_to(to_cell)
	#TODO: Announce turn to TurnManager

func move_to(to_cell: Vector2i) -> void:
	WorldGrid.move_entity(self, cell, to_cell)
	cell = to_cell
	position = cell_to_world(cell)

func swap_with(other: Entity) -> void:
	var other_cell: Vector2i = other.cell
	WorldGrid.swap_entities(self, other)
	other.cell = cell
	other.position = cell_to_world(cell)
	cell = other_cell
	position = cell_to_world(other_cell)

func world_to_cell(world_pos: Vector2) -> Vector2i:
	return Vector2i(world_pos / Constants.TILE_SIZE)

func cell_to_world(grid_pos: Vector2i) -> Vector2:
	return Vector2(grid_pos * Constants.TILE_SIZE)
