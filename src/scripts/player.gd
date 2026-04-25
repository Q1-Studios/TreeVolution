class_name Player

extends CharacterBody2D

@export var movement_controller : MovementController
@export var stat_controller : StatController

var PLAYER_MAX_HEALTH = 100
var player_health = 10
var player_damage = 10

var polen_damage_increase = 10
var polen_heal_amount = 1

var pollen_ability_cooldown = 10
var polen_attributes = {"damageBuff": [true, polen_damage_increase], "healing": [true, polen_heal_amount], "blocking": false}
@onready var health_manager = $HealthController
@onready var pollen_obj = preload("res://src/scenes/Pollen.tscn")

var polen_list = []
func _process(delta) -> void:
	spawn_polen()

func spawn_polen():
	if Input.is_action_just_pressed("Pollen ability"):
		var player_position = $".".position
		var temp_polen = pollen_obj.instantiate()
		get_tree().root.add_child(temp_polen)
		temp_polen.global_position = player_position 
		await get_tree().create_timer(pollen_ability_cooldown).timeout
		temp_polen.queue_free()

func _physics_process(delta: float) -> void:
	movement_controller.handleMovement(self, delta)
	for area in polen_list:
		area.affect_player(self, polen_attributes)
		await get_tree().create_timer(1*delta).timeout

func _on_bullet_detection_body_entered(body: Node2D) -> void:
	stat_controller.bullet_damage(self, body)

# area parameter -> polen area
func _on_polen_detection_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Polen")):
		if area not in polen_list:
			polen_list.append(area)

func _on_polen_detection_area_exited(area: Area2D) -> void:
	if (area.is_in_group("Polen")):
		polen_list.erase(area)
