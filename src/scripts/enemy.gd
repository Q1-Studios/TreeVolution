extends Character
class_name Enemy

@onready var dust_sprite = $DustAnimation
@onready var animated_sprite = $AnimatedSprite2D
@onready var pollen_obj = preload("res://src/scenes/Pollen.tscn")
@export var EnemyWalk:AudioStreamPlayer2D
@export var EnemyJump:AudioStreamPlayer2D
@export var EnemyDamage:AudioStreamPlayer2D
@export var EnemySword:AudioStreamPlayer2D #Use when Attak if(!EnemySword.playing): EnemySword.play()
			

var can_spawn_pollen: bool = true
var can_land: bool = false
var timer: float = pollen_life_time
var max_time: bool = 0.5

signal hit

func _ready() -> void:
	super()
	dust_sprite.stop()

func _physics_process(delta: float) -> void:
	super(delta)
	if !enabled:
		return
	play_animation()
	pass

func _process(delta):
	if Input.is_action_just_pressed("enemyPollen") && can_spawn_pollen:
		spawn_pollen()
		timer -= delta
	if(timer <= 0 && !can_spawn_pollen):
		can_spawn_pollen = true
		
func spawn_pollen() -> void:
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
		
func start_pollen_cooldown() -> void:
	timer = max_time
	can_spawn_pollen = false


func select_random_evolution() -> void:
	var all_evolutions = Evolutions.Evolution.values()
	var index: int = randi_range(0, all_evolutions.size() - 1)
	var evolution: Evolutions.Evolution = all_evolutions[index];
	print("Enemy chose evolution '%s'" % Evolutions.get_evolution_data(evolution).readable_name)
	apply_evolution_effects(evolution);
	
func take_damage(amount: float) -> void:
	super(amount)
	$AnimationPlayer.play("damage_taken")
	if(!EnemyDamage.playing):
			EnemyDamage.play()

func play_animation() -> void:
	if (velocity.x > 0 && velocity.y == 0) && !stun:
		animated_sprite.flip_h = velocity.x < 0
		animated_sprite.play("walk")
		if(!EnemyWalk.playing):
			EnemyWalk.play()
	elif (velocity.x < 0 && velocity.y == 0) && !stun:
		animated_sprite.flip_h = velocity.x < 0 
		animated_sprite.play("walk")
		if(!EnemyWalk.playing):
			EnemyWalk.play()
	elif velocity.y < 0:
		animated_sprite.play("jump")
		if(!EnemyJump.playing):
			EnemyJump.play()
	elif stun:
		animated_sprite.play("land")
		dust_sprite.play("dust")
	else:
		animated_sprite.play("idle")


func _on_bullet_blocker_body_entered(body: Node2D) -> void:
	if !body.is_in_group("bullets") and !body.is_in_group("Player"):
		return
	if body.is_in_group("bullets"):
		print("blocking")
	else:
		print("hitting")
		emit_signal("hit", 2*gun.bullet_damage)
