class_name Player
extends Character

@onready var animated_sprite = $PlayerMovementAnimation
@onready var pollen_obj = preload("res://src/scenes/Pollen.tscn")

var can_spawn_pollen: bool = true
var can_land: bool = false

var max_time: float = 0.5
var timer: float = pollen_life_time
var on_ground: bool = true
func _ready() -> void:
	health = 100
	
func _physics_process(delta: float) -> void:
	super(delta)
	if !enabled:
		return
		
	_handle_gun()
	play_animation()
 

func _process(delta) -> void:
	timer -= delta
	spawn_pollen()
	if(timer <= 0 && !can_spawn_pollen):
		can_spawn_pollen = true

func _handle_gun() -> void:
	var direction = get_global_mouse_position()
	gun.rotate_weapon(direction)
	
	if Input.is_action_pressed("shoot"):
		gun.shoot(direction, velocity)

func spawn_pollen():
	if Input.is_action_just_pressed("Pollen ability") && can_spawn_pollen:
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
	$AnimationPlayer.play("damage_taken")
	
func play_animation() -> void:
	if Input.is_action_pressed("moveRight") && !stun:
		animated_sprite.flip_h = velocity.x < 0
		animated_sprite.play("walk")
	elif Input.is_action_pressed("moveLeft") && !stun:
		animated_sprite.flip_h = velocity.x < 0 
		animated_sprite.play("walk")
	elif Input.is_action_just_pressed("jump") && !stun:
		animated_sprite.play("jump")
	elif velocity.y < 0:
		animated_sprite.play("airtime")
	elif stun:
		animated_sprite.play("land")
	else:
		animated_sprite.play("idle")
