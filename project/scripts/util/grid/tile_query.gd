class_name TileQuery
extends RefCounted

var _layers: Array[TileMapLayer] = []

func initialize(layers: Array[TileMapLayer]) -> void:
	_layers = layers

func is_walkable(cell: Vector2i) -> bool:
	if (_layers.is_empty()):
		push_warning("TileQuery: no TileMapLayers initiated.")
		return false
	var is_walkable_tile := false
	for layer in _layers:
		var tile_data: TileData = layer.get_cell_tile_data(cell)
		if tile_data == null:
			continue
		is_walkable_tile = true
		var walkable_data = tile_data.get_custom_data("is_walkable")
		if walkable_data is bool and not walkable_data:
			return false
	return is_walkable_tile
