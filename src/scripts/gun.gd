extends StaticBody2D
class_name GunController

var Bullet = preload("res://src/scenes/bullet.tscn")

@export_group("Weapon Stats")
@export var attack_cooldown: float = 0.1

@export_group("Bullet Attributes")
@export var bullet_damage: float = 3
@export var bullet_count: int = 1
@export var bullet_bounces: int = 1
@export var bullet_size: float = 1
@export var bullet_velocity: float = 1500

var can_shoot: bool = true;
const MULTI_BULLET_OFFSET: float = PI/18 # 10 degrees

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func rotate_weapon(direction: Vector2) -> void:
	var dir = direction - global_position
	if dir.length() > 5:
		rotation = dir.angle()
		
func shoot(direction: Vector2, character_velocity: Vector2) -> void:
	if !can_shoot:
		return
	can_shoot = false
	_spawn_bullets(direction, character_velocity)
	_start_shooting_cooldown()
		
func _start_shooting_cooldown() -> void:
		await get_tree().create_timer(attack_cooldown).timeout
		can_shoot = true
		
func _get_bullet_arrangement() -> Array[int]:
	var bullet_arrangement: Array[int] = []
	for i in range(0, bullet_count):
		var direction = -1 if i % 2 == 0 else 1
		var value = ceil((float(i) / 3 ))
		bullet_arrangement.append(value * direction)
	return bullet_arrangement

func _spawn_bullets(direction: Vector2, character_velocity: Vector2) -> void:
	var dir = direction - global_position

	for arrangement in _get_bullet_arrangement():
		# get offset for each bullet
		var offset = MULTI_BULLET_OFFSET * arrangement
		
		# clamp bullet rotation between +60° and -60°
		var angle = dir.angle()
		var is_aiming_left = dir.dot(Vector2.LEFT) > 0
		
		# calculate bullet rotation (max between +60° and -60°)
		var dir_mult = -1 if is_aiming_left else 1
		var clamp_angle_base = Vector2.LEFT.angle() if is_aiming_left else Vector2.RIGHT.angle()
		var min_bullet_rotation = dir_mult * clamp_angle_base - PI/3
		var max_bullet_rotation = dir_mult * clamp_angle_base + PI/3
		var bullet_rotation = clamp(angle + offset, min_bullet_rotation, max_bullet_rotation)
		
		# calculate bullet velocity
		var base_velocity = Vector2(bullet_velocity, 0).rotated(bullet_rotation)
		var final_velocity = character_velocity + base_velocity
		var dot_product = base_velocity.dot(character_velocity)
	
		if final_velocity.length() < character_velocity.length() or dot_product < 0:
			# ensure that player does not catch up to bullet
			final_velocity = base_velocity

		var bullet = Bullet.instantiate()
		bullet.spawn($Muzzle.global_position, bullet_rotation, final_velocity, bullet_size)
		bullet.set_bounces(bullet_bounces)
		bullet.set_damage(bullet_damage)
		get_tree().root.add_child(bullet)
	
func _set_bullet_attributes(damage: float, count: int, bounces: int, size: float, velocity: float) -> void:
	bullet_damage = damage
	bullet_count = count
	bullet_bounces = bounces
	bullet_size = size
	bullet_velocity = velocity
	
func _set_attack_cooldown(amount: float) -> void:
	attack_cooldown = amount
