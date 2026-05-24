class_name Guard
extends Entity

func _ready() -> void:
	can_be_remembered = false
	
	super()
	TurnManager.register_world_entity(self)
