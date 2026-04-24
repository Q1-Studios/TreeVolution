extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var health = 10
var pollen_attributes = {"Damage": 1, "Healing": 1, "Blocking": false}
var pollen_obj

func _ready():
	pollen_obj = get_node("")
	pass
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_pollen_damage() -> void:
	health -= 10
	print(health)
	
func _spawn_pollen(): 
	
	pass
