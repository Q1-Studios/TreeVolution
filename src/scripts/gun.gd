extends StaticBody2D

var Bullet = preload("res://src/scenes/bullet.tscn")

@export_group("Weapon Stats")
@export var attack_cooldown: float = 0.5

@export_group("Bullet Attributes")
@export var bullet_damage: float = 3
@export var bullet_count: int = 1
@export var bullet_bounces: int = 1
@export var bullet_size: float = 1
@export var bullet_velocity: float = 40000

var can_shoot: bool = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
		
func _physics_process(_delta: float) -> void:
	rotate_weapon()
	
	if(Input.is_action_pressed("shoot")):
		shoot()
	
func rotate_weapon() -> void:
	var dir = get_global_mouse_position() - global_position
	if dir.length() > 5:
		rotation = dir.angle()
		
func start_shooting_cooldown() -> void:
		await get_tree().create_timer(attack_cooldown).timeout
		can_shoot = true

func spawn_bullet() -> void:
	var dir = get_global_mouse_position() - global_position
	var bullet_rotation = dir.angle() + randf_range(-0.2, 0.2)
	var velocity = Vector2(bullet_velocity, 0).rotated(bullet_rotation)
		
	var bullet = Bullet.instantiate()
	bullet.spawn($Muzzle.global_position, bullet_rotation, velocity, bullet_size)
	bullet.set_bounces(bullet_bounces)
	bullet.set_damage(bullet_damage)
	get_tree().root.add_child(bullet)

func shoot() -> void:
	if !can_shoot:
		return
		
	can_shoot = false
	spawn_bullet()
	start_shooting_cooldown()
