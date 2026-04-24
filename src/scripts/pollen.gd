extends Node2D

signal start_effect
signal stop_effect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_pollen_entered() -> void:
	emit_signal("start_effect")

func _on_area_2d_body_exited(body: Node2D) -> void:
	emit_signal("stop_effect")
