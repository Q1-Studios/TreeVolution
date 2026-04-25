class_name Character
extends CharacterBody2D


var PLAYER_MAX_HEALTH: int = 100
var health:int = 10
var damage:int = 10

var pollen_heal_amount:int = 1
var pollen_damage_enemy_amount:int = 5
var pollen_life_time:int = 3
var pollen_summon_cooldown: int = 5

var pollen_list = [] # stores in what pollen areas wer are in
var pollen_effect_can_happen: bool = true

@export var movement_controller : MovementController
@export var animation_player : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func upgrade_pollen_heal_amount(upgrade_amount: int):
	pollen_heal_amount + upgrade_amount

func upgrade_pollen_damage_amount(upgrade_amount: int):
	pollen_damage_enemy_amount + upgrade_amount

func upgrade_pollen_summon_cooldown(upgrade_amount: int):
	pollen_summon_cooldown - upgrade_amount

func create_pollen(temp_pollen: Pollen) -> Pollen:
	temp_pollen.pollen_heal_amount = pollen_heal_amount
	temp_pollen.pollen_damage_enemy_amount = pollen_damage_enemy_amount
	temp_pollen.pollen_life_time = pollen_life_time
	temp_pollen.owner_call = self
	return temp_pollen


func _physics_process(delta: float) -> void:
	movement_controller.handleMovement(self, delta)
	var current_player_damage:int = 0
	for pollen in pollen_list:
		pollen_effect_trigger(pollen)


func pollen_effect_trigger(pollen: Pollen):
	if !pollen_effect_can_happen:
		return
	pollen_effect_can_happen = false
	if pollen.owner_call == self:
		health += pollen.pollen_heal_amount
		health = min(PLAYER_MAX_HEALTH, health)
		print(health)
	else:
		health -= pollen_damage_enemy_amount
	pollen_effect_cooldown()

func pollen_effect_cooldown():
	await get_tree().create_timer(1).timeout
	pollen_effect_can_happen = true


# singaling
func _on_bullet_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullets"):
		var bullet_damage: float = body.damage
		print("Collided with bullet, took %s damage " % str(bullet_damage))
		health -= bullet_damage
		animation_player.play("damage_taken")

# area parameter -> pollen area
func _on_pollen_detection_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Polen")):
		if area not in pollen_list:
			pollen_list.append(area)


func _on_pollen_detection_area_exited(area: Area2D) -> void:
	if (area.is_in_group("Polen")):
		pollen_list.erase(area)
