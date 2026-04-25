extends StaticBody2D

var Bullet = preload("res://src/scenes/bullet.tscn")

@export_group("Weapon Stats")
@export var damage: float = 3
@export var attack_cooldown: float = 0.01

@export_group("Bullet Attributes")
@export var bullet_count: int = 1
@export var bullet_bounces: int = 1
@export var bullet_size: float = 1
@export var bullet_velocity: float = 4000

var can_shoot: bool = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
		
func _physics_process(_delta: float) -> void:
	rotate_weapon()
	
	if(Input.is_action_pressed("shoot")):
		shoot()
	
func rotate_weapon():
	var dir = get_global_mouse_position() - global_position
	if dir.length() > 5:
		rotation = dir.angle()
		
func start_shooting_cooldown():
		await get_tree().create_timer(attack_cooldown).timeout
		can_shoot = true

func spawn_bullet():
	var dir = get_global_mouse_position() - global_position
	var velocity = Vector2(bullet_velocity, 0).rotated(dir.angle())
		
	var bullet = Bullet.instantiate()
	bullet.spawn($Muzzle.global_position, dir.angle(), velocity, bullet_size)
	bullet.set_bounces(bullet_bounces)
	get_tree().root.add_child(bullet)

func shoot():
	if !can_shoot:
		return
		
	can_shoot = false
	spawn_bullet()
	start_shooting_cooldown()
