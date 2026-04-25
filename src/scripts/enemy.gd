extends Character
class_name Enemy

func _ready() -> void:
	health = 100
	
func _physics_process(delta: float) -> void:
	super(delta)
	if health < 0:
		queue_free()
	pass
