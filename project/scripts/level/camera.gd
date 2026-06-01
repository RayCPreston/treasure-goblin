extends Camera2D

const ZOOM_STEP: float = 1.0
const ZOOM_MAX: float = 4.0

@export var smooth_speed: float = 3.0
@export var tile_deadzone_x: int = 15
@export var tile_deadzone_y: int = 6

var _camera_tween: Tween
var _base_scale: float = 1.0
var _current_zoom: int = 0
var _player_pos: Vector2 = Vector2.ZERO
var _target_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	GameEvents.zoom_in_requested.connect(zoom_in)
	GameEvents.zoom_out_requested.connect(zoom_out)
	GameEvents.player_pos_updated.connect(player_pos_updated)
	call_deferred("fit_camera")

func fit_camera() -> void:
	#_base_scale = ResolutionManager.get_snapped_scale() #TODO: Support configurable resolutions
	_base_scale = 1.0
	_current_zoom = 0
	zoom = Vector2(_base_scale, _base_scale)
	_target_pos = Vector2(_get_x_pos(), _get_y_pos())
	position = _target_pos

func zoom_in() -> void:
	_current_zoom = mini(_current_zoom + 1, int(ZOOM_MAX - _base_scale))
	var new_zoom: float = _get_new_zoom()
	_target_pos = Vector2(_get_x_pos(), _get_y_pos())
	_tweened_move(new_zoom, _get_clamped_pos(_target_pos))

func zoom_out() -> void:
	_current_zoom = maxi(_current_zoom - 1, 0)
	_target_pos = Vector2(_get_x_pos(), _get_y_pos())
	_tweened_move(_get_new_zoom(), _get_clamped_pos(_target_pos))

func _get_x_pos() -> float:
	if _current_zoom == 0:
		return MapConfig.get_map_pixel_width() / 2.0
	else:
		return _player_pos.x

func _get_y_pos() -> float:
	if _current_zoom == 0:
		return MapConfig.get_map_pixel_height() / 2.0
	else:
		return _player_pos.y

func player_pos_updated(player_pos: Vector2) -> void:
	_player_pos = player_pos
	if _current_zoom > 0:
		_apply_deadzone()

func _apply_deadzone() -> void:
	var deadzone_x: float = tile_deadzone_x * Constants.TILE_SIZE / zoom.x
	var deadzone_y: float = tile_deadzone_y * Constants.TILE_SIZE / zoom.y
	var screen_pos: Vector2 = _player_pos - position
	if abs(screen_pos.x) > deadzone_x + 0.5:
		_target_pos.x = _player_pos.x - (sign(screen_pos.x) * (deadzone_x - Constants.TILE_SIZE * 4))
		_tweened_move(_get_new_zoom(), _get_clamped_pos(_target_pos))
	if abs(screen_pos.y) > deadzone_y + 0.5:
		_target_pos.y = _player_pos.y - (sign(screen_pos.y) * (deadzone_y - Constants.TILE_SIZE * 4))
		_tweened_move(_get_new_zoom(), _get_clamped_pos(_target_pos))

func _get_new_zoom() -> float:
	return _base_scale + _current_zoom * ZOOM_STEP

func _tweened_move(target_zoom: float, target_pos: Vector2) -> void:
	if _camera_tween:
		_camera_tween.kill()
	_camera_tween = create_tween()
	_camera_tween.set_trans(Tween.TRANS_QUINT)
	_camera_tween.set_ease(Tween.EASE_IN_OUT)
	_camera_tween.set_parallel(true)
	_camera_tween.tween_property(self, "zoom", Vector2(target_zoom, target_zoom), 1.0 / smooth_speed)
	_camera_tween.tween_property(self, "position", target_pos, 1.0 / smooth_speed)

func _get_clamped_pos(target: Vector2) -> Vector2:
	if _current_zoom == 0:
		return target
	var half_w: float = (get_viewport_rect().size.x / 2.0) / _get_new_zoom()
	var half_h: float = (get_viewport_rect().size.y / 2.0) / _get_new_zoom()
	var max_x: float = MapConfig.get_map_pixel_width() - half_w
	var max_y: float = MapConfig.get_map_pixel_height() - half_h
	return Vector2(
		clampf(target.x, half_w, max_x),
		clampf(target.y, half_h, max_y)
	)
