extends RigidBody2D
class_name Bullet

@onready var despawn_timer: Timer = $DespawnTimer

var fired = false
var bounce_amount: int = 1
var size: float = 1.0
var damage: float = 0.0

func spawn(_position: Vector2, _direction: float, _velocity: Vector2, _size: float):
	position = _position
	rotation = _direction
	size = _size
	linear_velocity = _velocity
	
func set_damage(amount: float) -> void:
	damage = amount

func get_damage() -> float:
	return damage
	
func set_bounces(amount: int):
	bounce_amount = amount
	
func update_size() -> void:
	scale = Vector2(size, size)
	
func check_for_collision() -> void:
	
	# check for colliding bodies
	for node in get_colliding_bodies():
		var parent: Node2D = node.get_parent()
		var collider_is_character: bool = node is CharacterBody2D or parent is CharacterBody2D
		if !collider_is_character:
			# only bounce of all other things except character
			bounce_amount = bounce_amount - 1
		else:
			# if collision with player, remove the bullet
			delete()
			return
	
	# if bounce amount is hit, remove child from tree
	if bounce_amount <= 0:
		delete()
		return

func delete() -> void:
	if is_queued_for_deletion():
		return
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_contacts_reported = 1
	contact_monitor = true
	update_size()
	despawn_timer.start()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if is_queued_for_deletion():
		return
	
	update_size()
	check_for_collision()


func _on_despawn_timer_timeout() -> void:
	delete()
