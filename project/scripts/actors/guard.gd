class_name Guard
extends Entity

const COLOR_GREEN: Color = Color.LIME_GREEN
const COLOR_YELLOW: Color = Color.YELLOW
const COLOR_RED: Color = Color.RED
const INTENSITY_HIGH: float = 0.6
const INTENSITY_LOW: float = 0.3

var facing: Facing = Facing.NORTH
var _fov: GuardFov = GuardFov.new()
var _last_cone_cells: Array[Vector2i] = []

func _ready() -> void:
	can_be_remembered = false
	super()
	TurnManager.register_world_entity(self)

func take_turn() -> void:
	_draw_cone()
	end_turn()

func _draw_cone() -> void:
	_reset_cone()
	var zones: Array[Array] = _fov.compute(cell, facing)
	var inner: Array[Vector2i] = zones[0]
	var outer: Array[Vector2i] = zones[1]
	for cone_cell in inner:
		TileManager.set_cell_modulate(cone_cell, COLOR_GREEN)
		_last_cone_cells.append(cone_cell)
	for cone_cell in outer:
		TileManager.set_cell_modulate(cone_cell, COLOR_YELLOW)
		_last_cone_cells.append(cone_cell)

func _reset_cone() -> void:
	for cone_cell in _last_cone_cells:
		TileManager.set_cell_modulate(cone_cell, VisionManager.get_cell_color(cone_cell))
	_last_cone_cells.clear()

func _get_color(base_color: Color, intensity: float) -> Color:
	return Color(base_color.r, base_color.g, base_color.b, intensity)
