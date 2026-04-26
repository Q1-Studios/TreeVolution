extends Character
class_name Enemy

@onready var sword_animation = $SwordAnimation
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

var wants_to_spawn_pollen: bool = false

var attack_animation_played: bool = false
var dust_animation_played: bool = false

signal hit

func _ready() -> void:
	super()
	sword_animation.hide()
	dust_sprite.hide()

func _physics_process(delta: float) -> void:
	super(delta)
	if !enabled:
		return
	play_animation()
	pass

func _process(delta):
	super(delta)
	if wants_to_spawn_pollen && can_spawn_pollen:
		spawn_pollen()
	timer -= delta
	if(timer <= 0 && !can_spawn_pollen):
		can_spawn_pollen = true
	wants_to_spawn_pollen = false
	if attack_animation_played && !sword_animation.is_playing():
		sword_animation.hide()
	if dust_animation_played && !dust_sprite.is_playing():
		dust_sprite.hide()

func spawn_pollen() -> void:
	timer = pollen_summon_cooldown
	can_spawn_pollen = false
	var player_position = $".".position
	var temp_pollen = pollen_obj.instantiate()
	temp_pollen = create_pollen(temp_pollen)
	get_tree().root.add_child(temp_pollen)
	temp_pollen.global_position = player_position 
	temp_pollen.global_position[1] -= 400
	temp_pollen.global_position[0] += sign($".".velocity[0])*300
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
	
func apply_evolution_effects(evolution: Evolutions.Evolution):
	# Evolutions on enemy do have different meaning since
	# he brings a knife to a gunfight
	match evolution:
		Evolutions.Evolution.PLAYER_HEALTH:
			PLAYER_MAX_HEALTH += 20
			pass
		Evolutions.Evolution.PLAYER_SPEED:
			movement_controller.max_speed += 200
			pass
		Evolutions.Evolution.PISTOL_COOLDOWN:
			movement_controller.jumpForce += 100
			pass
		Evolutions.Evolution.PLAYER_POLLEN_COOLDOWN:
			var new_cooldown = max(0.5, pollen_summon_cooldown - 0.2)
			pollen_summon_cooldown = new_cooldown
			pass
		Evolutions.Evolution.POLLEN_DAMAGE:
			pollen_damage_enemy_amount += 0.2
			pollen_damage_upgrade_count += POLLEN_COLOR_UPGRADE_STEP
			pass
		Evolutions.Evolution.PISTOL_BULLET_SIZE, Evolutions.Evolution.POLLEN_BLOCK:
			pollen_block_amount += 1
			pollen_block_upgrade_count += POLLEN_COLOR_UPGRADE_STEP
			pass
		Evolutions.Evolution.POLLEN_HEAL:
			pollen_heal_amount += 0.2
			pollen_heal_upgrade_count += POLLEN_COLOR_UPGRADE_STEP
			pass
		Evolutions.Evolution.PISTOL_BULLET_DAMAGE, Evolutions.Evolution.PISTOL_BULLET_SPEED:
			gun.bullet_damage += 5
			var new_health: float = max(20, PLAYER_MAX_HEALTH - 10)
			PLAYER_MAX_HEALTH = new_health
			pass
		Evolutions.Evolution.PISTOL_BULLET_BOUNCES:
			var new_sampling_time = max(0.1, movement_controller.sampling_time - 0.1)
			movement_controller.sampling_time = new_sampling_time
			pass 
		Evolutions.Evolution.PISTOL_BULLET_COUNT:
			var new_lineup_probability = max(0, movement_controller.lineup_probability - 0.02)
			movement_controller.lineup_probability = new_lineup_probability
			pass
			
	
func take_damage(amount: float) -> void:
	super(amount)
	$AnimationPlayer.play("damage_taken")
	if(!EnemyDamage.playing):
		EnemyDamage.play()

func play_animation() -> void:
	if (velocity.x > 0 && velocity.y == 0) && !stun:
		animated_sprite.flip_h = velocity.x < 0
		sword_animation.flip_h = velocity.x < 0
		animated_sprite.play("walk")
		if(!EnemyWalk.playing):
			EnemyWalk.play()
	elif (velocity.x < 0 && velocity.y == 0) && !stun:
		animated_sprite.flip_h = velocity.x < 0 
		sword_animation.flip_h = velocity.x < 0
		animated_sprite.play("walk")
		if(!EnemyWalk.playing):
			EnemyWalk.play()
	elif velocity.y < 0:
		animated_sprite.play("jump")
		if(!EnemyJump.playing):
			EnemyJump.play()
	elif stun:
		animated_sprite.play("land")
		dust_animation_played = false
		if !dust_animation_played && !dust_sprite.is_playing():
			dust_sprite.visible = true
			dust_sprite.play("dust")
			dust_animation_played = true
	else:
		animated_sprite.play("idle")


func _on_bullet_blocker_body_entered(body: Node2D) -> void:
	if !body.is_in_group("bullets") and !body.is_in_group("Player"):
		return
	if body.is_in_group("bullets"):
		print("blocking")
		wants_to_spawn_pollen = true
	else:
		print("hitting")
		emit_signal("hit", 2 * gun.bullet_damage)
		attack_animation_played = false
		if !attack_animation_played && !sword_animation.is_playing():
			sword_animation.visible = true
			sword_animation.play("swordAttack")
			attack_animation_played = true
