class_name Player
extends Entity

func _ready() -> void:
	super()
	TurnManager.register_player(self)

func _unhandled_input(event: InputEvent) -> void:
	if not TurnManager.is_player_turn():
		return
	var action: PlayerInput.Action = PlayerInput.get_input_action(event)
	if action == PlayerInput.Action.NONE:
		return
	elif action == PlayerInput.Action.WAIT:
		wait()
	elif action == PlayerInput.Action.MOVE:
		var direction: Vector2i = PlayerInput.get_move_direction(event)
		try_move_to(cell + direction)
	get_viewport().set_input_as_handled()
