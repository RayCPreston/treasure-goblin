extends Node

signal cell_state_changed

const COLOR_VISIBLE: Color = Color(1.0, 1.0, 1.0, 1.0)
const COLOR_REMEMBERED: Color = Color(0.4, 0.4, 0.4, 1.0)
const COLOR_UNSEEN: Color = Color(0.0, 0.0, 0.0, 1.0)

var _vision: Dictionary = {}
var _guard_cones: Dictionary = {}

func initialize_player(player: Player) -> void:
	player.vision_updated.connect(_on_vision_updated)

func initialize_guard(guard: Guard) -> void:
	guard.cone_updated.connect(
		func(inner: Array[Vector2i], outer: Array[Vector2i], color: Color) -> void:
			_on_cone_updated(guard, inner, outer, color)
	)

func get_state(cell: Vector2i) -> PlayerFov.VisionState:
	return _vision.get(cell, PlayerFov.VisionState.UNSEEN)

func get_cell_color(cell: Vector2i) -> Color:
	match get_state(cell):
		PlayerFov.VisionState.UNSEEN: 
			return COLOR_UNSEEN
		PlayerFov.VisionState.REMEMBERED: 
			return COLOR_REMEMBERED
	for guard: Guard in _guard_cones:
		if not guard.visible:
			continue
		var cone: Dictionary = _guard_cones[guard]
		if cone["inner"].has(cell):
			return cone["color"]
		if cone["outer"].has(cell):
			return cone["color"]
	return COLOR_VISIBLE

func _clear_guard_cones() -> void:
	_guard_cones.clear()

func _on_vision_updated(cells: Dictionary) -> void:
	_vision = cells
	TileManager.notify_vision_update()
	cell_state_changed.emit()

func _on_cone_updated(guard: Guard, inner: Array[Vector2i], outer: Array[Vector2i], color: Color) -> void:
	var inner_dict: Dictionary = {}
	var outer_dict: Dictionary = {}
	for cell: Vector2i in inner:
		inner_dict[cell] = true
	for cell: Vector2i in outer:
		outer_dict[cell] = true
	_guard_cones[guard] = { "inner": inner_dict, "outer": outer_dict, "color": color }
	TileManager.notify_vision_update()
	cell_state_changed.emit()
