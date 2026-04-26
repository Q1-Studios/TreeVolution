extends Character
class_name Enemy

@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	health = 100
	
func _physics_process(delta: float) -> void:
	super(delta)
	
	if !enabled:
		return
	
	play_animation()
	pass

func select_random_evolution() -> void:
	var all_evolutions = Evolutions.Evolution.values()
	var index: int = randi_range(0, all_evolutions.size() - 1)
	var evolution: Evolutions.Evolution = all_evolutions[index];
	print("Enemy chose evolution '%s'" % Evolutions.get_evolution_data(evolution).readable_name)
	apply_evolution_effects(evolution);

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
