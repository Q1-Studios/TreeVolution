extends StaticBody2D

var Bullet = preload("res://src/scenes/bullet.tscn")

@export_group("Weapon Stats")
@export var attack_cooldown: float = 0.5

@export_group("Bullet Attributes")
@export var bullet_damage: float = 3
@export var bullet_count: int = 1
@export var bullet_bounces: int = 1
@export var bullet_size: float = 1
@export var bullet_velocity: float = 8000

var can_shoot: bool = true;
const MULTI_BULLET_OFFSET: float = PI/18 # 10 degrees

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
		
func get_bullet_arrangement() -> Array[int]:
	var bullet_arrangement: Array[int] = []
	for i in range(0, bullet_count):
		var direction = -1 if i % 2 == 0 else 1
		var value = ceil((float(i) / 3 ))
		bullet_arrangement.append(value * direction)
		
	print("Bullet arangement: "+ str(bullet_arrangement))
	return bullet_arrangement

func spawn_bullet() -> void:
	var dir = get_global_mouse_position() - global_position
	
	for arrangement in get_bullet_arrangement():
		var offset = MULTI_BULLET_OFFSET * arrangement
		# clamp bullet rotation between +60° and -60°
		var bullet_rotation = clamp(dir.angle() + offset, -PI/3, PI/3)
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
	
func set_bullet_attributes(damage: float, count: int, bounces: int, size: float, velocity: float) -> void:
	bullet_damage = damage
	bullet_count = count
	bullet_bounces = bounces
	bullet_size = size
	bullet_velocity = velocity
	
func set_attack_cooldown(amount: float) -> void:
	attack_cooldown = amount
