class_name Player
extends Character

@onready var model_container = $ModelContainer
@onready var animated_sprite = $ModelContainer/PlayerMovementAnimation
@onready var dust_sprite = $DustAnimation
@onready var pollen_obj = preload("res://src/scenes/Pollen.tscn")
@onready var health_bar = $HealthBar

@export var playerShoot:AudioStreamPlayer2D
@export var playerWalk:AudioStreamPlayer2D
@export var playerDamage:AudioStreamPlayer2D
@export var playerJump:AudioStreamPlayer2D

const WEAPON_RADIUS: float = 900.0

var can_spawn_pollen: bool = true
var can_land: bool = false
var max_time: float = 0.5
var timer: float = pollen_life_time
var on_ground: bool = true

var dust_animation_played: bool = false

func _ready() -> void:
	super()
	dust_sprite.hide()
	health_bar.value = health 
	health_bar.max_value = PLAYER_MAX_HEALTH


func _physics_process(delta: float) -> void:
	super(delta)
	if !enabled:
		return
		
	_handle_gun()
	play_animation()
	if dust_animation_played && !dust_sprite.is_playing():
		dust_sprite.hide()
 

func _process(delta) -> void:
	super(delta)
	timer -= delta
	if Input.is_action_just_pressed("Pollen ability") && can_spawn_pollen:
		spawn_pollen()
	if(timer <= 0 && !can_spawn_pollen):
		can_spawn_pollen = true
	health_bar.value = health

func _handle_gun() -> void:
	var mouse_pos = get_global_mouse_position()
	var player_center = global_position
	var angle = player_center.angle_to_point(mouse_pos)
	gun.position = Vector2(cos(angle), sin(angle)) * WEAPON_RADIUS
	gun.rotate_weapon(mouse_pos)
	
	if Input.is_action_pressed("shoot"):
		if(!playerShoot.playing):
			playerShoot.play()
		gun.shoot(mouse_pos, velocity)

func spawn_pollen():
	timer = pollen_summon_cooldown
	can_spawn_pollen = false
	var player_position = $".".position
	var temp_pollen = pollen_obj.instantiate()
	temp_pollen = create_pollen(temp_pollen)
	get_tree().root.add_child(temp_pollen)
	temp_pollen.global_position = player_position
	await get_tree().create_timer(pollen_life_time).timeout
	if temp_pollen:
		temp_pollen.queue_free()
		start_pollen_cooldown()
		
func start_pollen_cooldown():
	timer = max_time
	can_spawn_pollen = false
	
func take_damage(amount: float) -> void:
	super(amount)
	if(!playerDamage.playing):
		playerDamage.play()
	$AnimationPlayer.play("damage_taken")
	
func play_animation() -> void:
	if Input.is_action_pressed("moveRight") && !stun:
		if(!playerWalk.playing):
			playerWalk.play()
		model_container.scale.x = abs(model_container.scale.x)
		animated_sprite.play("walk")
	elif Input.is_action_pressed("moveLeft") && !stun:
		if(!playerWalk.playing):
			playerWalk.play()
		model_container.scale.x = -abs(model_container.scale.x)
		animated_sprite.play("walk")
	elif Input.is_action_just_pressed("jump") && !stun:
		if(!playerJump.playing):
			playerJump.play()
		animated_sprite.play("jump")
	elif velocity.y < 0:
		animated_sprite.play("airtime")
	elif stun:
		animated_sprite.play("land")
		dust_animation_played = false
		if !dust_animation_played && !dust_sprite.is_playing():
			dust_sprite.visible = true
			dust_sprite.play("dust")
			dust_animation_played = true
	else:
		animated_sprite.play("idle")


func _on_enemy_hit(damage) -> void:
	take_damage(damage)
