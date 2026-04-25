extends Node2D

signal start_effect
signal stop_effect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_bullet_2d_body_entered(body: Node2D) -> void:
	print("drd")
	if body.is_in_group("bullets"):
		body.queue_free()
