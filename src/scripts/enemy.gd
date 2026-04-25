extends CharacterBody2D


@export var health = 100

func _physics_process(delta: float) -> void:
	if health < 0:
		queue_free()
	pass


func _on_bullet_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullets"):
		var bullet_damage: float = body.get_damage()
		print("Enemy collided with bullet, took %s damage " % str(bullet_damage))
		health -= bullet_damage
		$AnimationPlayer.play("damage_taken")
