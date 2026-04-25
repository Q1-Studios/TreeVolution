extends RigidBody2D

var velocity: Vector2 = Vector2.ZERO
var fired = false
var bounce_amount: int = 1
var size: float = 1.0
var damage: float = 0.0

func spawn(_position: Vector2, _direction: float, _velocity: Vector2, _size: float):
	position = _position
	rotation = _direction
	velocity = _velocity
	size = _size
	
func set_damage(amount: float) -> void:
	damage = amount

func get_damage() -> float:
	return damage
	
func set_bounces(amount: int):
	bounce_amount = amount
	
func update_size() -> void:
	scale = Vector2(size, size)
	
func move(delta: float) -> void:
	# apply impulse only once
	if !fired:
		apply_central_impulse(velocity * delta)
		fired = true
	
func check_for_collision() -> void:
	# check for colliding bodies
	bounce_amount = bounce_amount - get_contact_count()
		
	# if bounce amount is hit, remove child from tree
	if bounce_amount <= 0:
		queue_free()
		return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_contacts_reported = 1
	contact_monitor = true
	update_size()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_queued_for_deletion():
		return
	
	update_size()
	check_for_collision()
	move(delta)
