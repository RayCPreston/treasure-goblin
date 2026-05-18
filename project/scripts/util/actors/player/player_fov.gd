class_name PlayerFov

enum VisionState { UNSEEN, REMEMBERED, VISIBLE }

var max_range = 10
var _memory: Dictionary = {}

const _OCTANTS: Array = [
	[Vector2i(0, -1), Vector2i(1, 0)],   #N
	[Vector2i(1, -1), Vector2i(0, 1)],   #NE
	[Vector2i(1, 0),  Vector2i(0, 1)],   # E
	[Vector2i(1, 1),  Vector2i(0, -1)],  # SE
	[Vector2i(0, 1),  Vector2i(-1, 0)],  # S
	[Vector2i(-1, 1), Vector2i(0, -1)],  # SW
	[Vector2i(-1, 0), Vector2i(0, -1)],  # W
	[Vector2i(-1,-1), Vector2i(0, 1)],   # NW
]

func compute(origin: Vector2i) -> Dictionary:
	for cell in _memory:
		if _memory[cell] == VisionState.VISIBLE:
			_memory[cell] = VisionState.REMEMBERED
	_memory[origin] = VisionState.VISIBLE
	for octant in range(8):
		_scan(origin, octant, 1, 0.0, 1.0)
	return _memory

func get_state(cell: Vector2i) -> VisionState:
	return _memory.get(cell, VisionState.UNSEEN)

func is_visible(cell: Vector2i) -> bool:
	return get_state(cell) == VisionState.VISIBLE

func _scan(origin: Vector2i, octant: int, col_dist: int, start_slope: float, end_slope: float) -> void:
	if col_dist > max_range:
		return
	var col_step: Vector2i = _OCTANTS[octant][0]
	var row_step: Vector2i = _OCTANTS[octant][1]
	var previous_was_blocker: bool = false
	var current_start: float = start_slope
	var row_min: int = int(floor(start_slope * float(col_dist) + 0.5))
	var row_max: int = int(floor(end_slope * float(col_dist) + 0.5))
	for row in range(row_min, row_max + 1):
		var cell: Vector2i = origin + col_step * col_dist + row_step * row
		var near_slope: float = (float(row) - 0.5) / (float(col_dist) + 0.5)
		var far_slope: float = (float(row) + 0.5) / (float(col_dist) - 0.5) \
			if col_dist > 1 else (float(row) + 0.5) / 0.5
		if near_slope > end_slope:
			break
		if far_slope < current_start:
			continue
		var dist: int = maxi(abs(cell.x - origin.x), abs(cell.y - origin.y))
		if dist <= max_range:
			_memory[cell] = VisionState.VISIBLE
		var opaque: bool = TileManager.is_opaque(cell)
		if opaque:
			if not previous_was_blocker:
				_scan(origin, octant, col_dist + 1, current_start, near_slope)
			previous_was_blocker = true
			current_start = far_slope
		else:
			if previous_was_blocker:
				current_start = near_slope
			previous_was_blocker = false
	if not previous_was_blocker:
		_scan(origin, octant, col_dist + 1, current_start, end_slope)
