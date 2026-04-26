extends StaticBody2D
class_name GunController

var Bullet_Scene = preload("res://src/scenes/bullet.tscn")

@export_group("Weapon Stats")
@export var attack_cooldown: float = 0.5

@export_group("Bullet Attributes")
@export var bullet_damage: float = 10
@export var bullet_count: int = 1
@export var bullet_bounces: int = 1
@export var bullet_size: float = 1
@export var bullet_velocity: float = 1500

@onready var sprite = $Sprite2D

const MAX_BULLET_SPREAD: float = PI/4

var can_shoot: bool = true;

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
		
func _get_bullet_arrangement() -> Array[float]:
	var offsets: Array[float] = []
	
	if bullet_count == 1:
		offsets.append(0.0)
		return offsets
	
	for i in range(bullet_count):
		var step = float(i) / float(bullet_count - 1)
		var offset = lerp(-MAX_BULLET_SPREAD, MAX_BULLET_SPREAD, step)
		offsets.append(offset)
	return offsets

func _spawn_bullets(direction: Vector2, character_velocity: Vector2) -> void:
	var base_angle = (direction - global_position).angle()

	for offset in _get_bullet_arrangement():
		# get roation for each bullet
		var bullet_rotation = base_angle + offset
		
		# calculate bullet velocity
		var base_velocity = Vector2(bullet_velocity, 0).rotated(bullet_rotation)
		var final_velocity = character_velocity + base_velocity
		var dot_product = base_velocity.dot(character_velocity)
	
		if final_velocity.length() < character_velocity.length() or dot_product < 0:
			# ensure that player does not catch up to bullet
			final_velocity = base_velocity

		var bullet = Bullet_Scene.instantiate()
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
