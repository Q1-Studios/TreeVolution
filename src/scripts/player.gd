extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var MAX_HEALTH = 100
var health = 100
var damage = 10
var in_pollen = false
var damage_amount = 10
var heal_amount = 1
var pollen_attributes = {"damageBuff": [false, damage_amount], "healing": [false, heal_amount], "blocking": false}
@onready var health_manager = $HealthController
	

func pollen_healing(healing_array):
	var new_health
	while(in_pollen):
		if(healing_array[0]):
			new_health = health + healing_array[1]
			if (health > MAX_HEALTH):	#idk why had issue with clamp method
				health = MAX_HEALTH

func pollen_damage_buff(damage_buff_array):
	var new_damage = damage + damage_buff_array[1]
	while(in_pollen):
		if(damage_buff_array[0]):
			damage = new_damage


func _on_pollen_start_effect() -> void:
	in_pollen = true


func _on_pollen_stop_effect() -> void:
	in_pollen = false
