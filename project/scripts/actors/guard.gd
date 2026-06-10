class_name Guard
extends Entity

signal cone_updated(inner: Array[Vector2i], outer: Array[Vector2i], color: Color, is_segmented: bool)

const COLOR_GREEN: Color = Color(0.02, 1.0, 0.02, 1.0)
const COLOR_YELLOW: Color = Color.YELLOW
const COLOR_RED: Color = Color.RED
const INTENSITY_HIGH: float = 0.8
const INTENSITY_LOW: float = 0.5

var facing: Facing = Facing.WEST
var _fov: GuardFov = GuardFov.new()

func _ready() -> void:
	can_be_remembered = false
	super()
	VisionManager.initialize_guard(self)
	TurnManager.register_world_entity(self)

func take_turn() -> void:
	compute_vision()
	end_turn()

func compute_vision() -> void:
	var zones: Array[Array] = _fov.compute(cell, facing)
	cone_updated.emit(zones[0], zones[1], _get_cone_color(), true)

func _get_cone_color() -> Color:
	return COLOR_GREEN
