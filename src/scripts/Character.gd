class_name Character
extends CharacterBody2D

signal die(character: Character);

var PLAYER_MAX_HEALTH: float = 100
var health: float = 10
var damage: float = 10

var pollen_heal_amount: float = 1
var pollen_damage_enemy_amount: float = 5
var pollen_block_amount: int = 2
var pollen_life_time: float = 3
var pollen_summon_cooldown: float = 5

var pollen_heal_upgrade_count: float = 0.5
var pollen_damage_upgrade_count: float = 0.5
var pollen_block_upgrade_count: float = 0.5

const POLLEN_COLOR_UPGRADE_STEP: float = 0.1

var pollen_list = [] # stores in what pollen areas wer are in
var pollen_effect_can_happen: bool = true

var high_fall: bool = false
var stun: bool = false

@export var enabled: bool = true
@export var movement_controller : MovementController
@export var animation_player : AnimationPlayer
@export var gun: GunController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = PLAYER_MAX_HEALTH
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func reset() -> void:
	health = PLAYER_MAX_HEALTH

func create_pollen(temp_pollen: Pollen) -> Pollen:
	temp_pollen.pollen_heal_amount = pollen_heal_amount
	temp_pollen.pollen_damage_enemy_amount = pollen_damage_enemy_amount
	temp_pollen.pollen_life_time = pollen_life_time
	temp_pollen.pollen_block_amount = pollen_block_amount
	temp_pollen.pollen_damage_upgrade_count = pollen_damage_upgrade_count
	temp_pollen.pollen_heal_upgrade_count = pollen_heal_upgrade_count
	temp_pollen.pollen_block_upgrade_count = pollen_block_upgrade_count
	temp_pollen.owner_call = self
	return temp_pollen

func _physics_process(_delta: float) -> void:
	if !enabled:
		return
	check_stun()
	if movement_controller:
		if !stun:
			movement_controller.handleMovement(self)
		else:
			await get_tree().create_timer(0.5).timeout
			stun = false
			high_fall = false
			
	for pollen in pollen_list:
		pollen_effect_trigger(pollen)
		

func check_stun():
	if velocity.y > 6000:
		high_fall = true
	if high_fall && is_on_floor():
		stun = true

"""
if velocity greater 6000 we are in free fall -> high_fall true
we then land on floor -> is on floor = true
stun = is on floor + highfall

fucntion:
	check velocity and store high fall

when not stun -> we set highfall to false
after pause we cam set stun to false
"""
func take_damage(amount: float) -> void:
	var new_health: float = max(0.0, health - amount)
	self.health = new_health
	if health <= 0:
		die.emit(self)

func healing(amount) -> void:
	var new_health = min(PLAYER_MAX_HEALTH, health + amount)
	health = new_health
	
func handle_high_fall() -> bool:
	if velocity.y > 6000 && is_on_floor():
		high_fall = true
		print(2)
		return high_fall
	else:
		high_fall = false
		return high_fall
		
func pollen_effect_trigger(pollen: Pollen):
	if !pollen_effect_can_happen:
		return
	pollen_effect_can_happen = false
	if pollen.owner_call == self:
		healing(pollen.pollen_heal_amount)
	else:
		take_damage(pollen.pollen_damage_enemy_amount)
		
	pollen_effect_cooldown()

func pollen_effect_cooldown():
	await get_tree().create_timer(1).timeout
	pollen_effect_can_happen = true
	
func set_enabled(_enabled: bool) -> void:
	self.enabled = _enabled

func apply_evolution_effects(evolution: Evolutions.Evolution):
	# TODO: balancing -> done :D
	match evolution:
		Evolutions.Evolution.PLAYER_HEALTH:
			PLAYER_MAX_HEALTH += 20
			pass
		Evolutions.Evolution.PLAYER_SPEED:
			movement_controller.max_speed += 200
			pass
		Evolutions.Evolution.PISTOL_COOLDOWN:
			var new_cooldown: float = max(0.01, gun.attack_cooldown - 0.05)
			gun.attack_cooldown = new_cooldown
			pass
		Evolutions.Evolution.PLAYER_POLLEN_COOLDOWN:
			var new_cooldown = max(0.5, pollen_summon_cooldown - 0.2)
			pollen_summon_cooldown = new_cooldown
			pass
		Evolutions.Evolution.POLLEN_DAMAGE:
			pollen_damage_enemy_amount += 0.2
			pollen_damage_upgrade_count += POLLEN_COLOR_UPGRADE_STEP
			pass
		Evolutions.Evolution.POLLEN_BLOCK:
			pollen_block_amount += 1
			pollen_block_upgrade_count += POLLEN_COLOR_UPGRADE_STEP
			pass
		Evolutions.Evolution.POLLEN_HEAL:
			pollen_heal_amount += 0.2
			pollen_heal_upgrade_count += POLLEN_COLOR_UPGRADE_STEP
			pass
		Evolutions.Evolution.PISTOL_BULLET_SIZE:
			gun.bullet_size += 1.2
			gun.bullet_velocity -= 50
			pass
		Evolutions.Evolution.PISTOL_BULLET_SPEED:
			gun.bullet_velocity += 900
			pass
		Evolutions.Evolution.PISTOL_BULLET_DAMAGE:
			gun.bullet_damage += 5
			var new_health: float = max(20, PLAYER_MAX_HEALTH - 10)
			PLAYER_MAX_HEALTH = new_health
			pass
		Evolutions.Evolution.PISTOL_BULLET_BOUNCES:
			gun.bullet_bounces += 2
			gun.bullet_velocity -= 200 
			pass
		Evolutions.Evolution.PISTOL_BULLET_COUNT:
			gun.bullet_count += 2
			var new_damage: float = max(0.5, gun.bullet_damage - 1)
			gun.bullet_damage = new_damage
			pass

# singaling
func _on_bullet_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullets"):
		var bullet_damage: float = body.damage
		take_damage(bullet_damage)
		

# area parameter -> pollen area
func _on_pollen_detection_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Polen")):
		if area not in pollen_list:
			pollen_list.append(area)


func _on_pollen_detection_area_exited(area: Area2D) -> void:
	if (area.is_in_group("Polen")):
		pollen_list.erase(area)
		
		
func _on_evolution_selected(evolution: Evolutions.Evolution):
	apply_evolution_effects(evolution)
