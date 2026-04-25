class_name StatController

extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func bullet_damage(player, body):
	if body.is_in_group("bullets"):
		var bullet_damage: float = body.damage
		print("Collided with bullet, took %s damage " % str(bullet_damage))
		player.player_health -= bullet_damage
