class_name Guard
extends Entity

func _ready() -> void:
	super()
	TurnManager.register_world_entity(self)
