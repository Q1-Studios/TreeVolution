extends Character
class_name Enemy

@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	health = 100
	
func _physics_process(delta: float) -> void:
	super(delta)
	
	if !enabled:
		return
	
	if health < 0:
		queue_free()
	play_animation()
	pass


func play_animation() -> void:
	if velocity.x > 0 && velocity.y == 0:
		animated_sprite.flip_h = velocity.x < 0
		animated_sprite.play("walk")
	elif velocity.x < 0 && velocity.y == 0:
		animated_sprite.flip_h = velocity.x < 0 
		animated_sprite.play("walk")
	elif velocity.y < 0:
		animated_sprite.play("jump")
	else:
		animated_sprite.play("idle")
