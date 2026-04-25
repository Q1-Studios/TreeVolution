class_name Player

extends CharacterBody2D

@export var movement_controller : MovementController

var MAX_HEALTH = 100
var health = 100
var damage = 10
var in_pollen = false
var damage_amount = 10
var heal_amount = 1
var pollen_ability_cooldown = 10
var pollen_attributes = {"damageBuff": [false, damage_amount], "healing": [false, heal_amount], "blocking": false}
@onready var health_manager = $HealthController
@onready var pollen_obj = preload("res://src/scenes/Pollen.tscn")


func _process(dealta) -> void:
	spawn_pollen()
	


func spawn_pollen():
	if Input.is_action_just_pressed("Pollen ability"):
		var player_position = $".".position
		var temp_pollen = pollen_obj.instantiate()
		get_tree().root.add_child(temp_pollen)
		temp_pollen.global_position = player_position 
		await get_tree().create_timer(pollen_ability_cooldown).timeout
		temp_pollen.queue_free()


func _physics_process(delta: float) -> void:
	movement_controller.handleMovement(self, delta)
	
func pollen_healing(healing_array):
	var new_health
	if(healing_array[0]):
		new_health = health + healing_array[1]
		health = new_health
		if (health > MAX_HEALTH):	#idk why had issue with clamp method
			health = MAX_HEALTH
	print(health)

func pollen_damage_buff(damage_buff_array):
	var new_damage = damage + damage_buff_array[1]
	if(damage_buff_array[0]):
		damage = new_damage

	
func _on_bullet_detection_body_entered(body: Node2D) -> void:
	print("S")
	if body.is_in_group("bullets"):
		var bullet_damage: float = body.get_damage()
		print("Collided with bullet, took %s damage " % str(bullet_damage))
		health -= bullet_damage
	

func _on_bullet_detection_area_entered(area: Area2D) -> void:
	while area.is_in_group("Polen"):
		print("s")
		pollen_healing(pollen_attributes["healing"])
		pollen_damage_buff(pollen_attributes["damageBuff"])
		await get_tree().create_timer(1).timeout

 
