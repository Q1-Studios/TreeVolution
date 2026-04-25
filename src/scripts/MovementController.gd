class_name MovementController
extends Node


@export_group("Character & Model")
@export var model_container : Node3D 

@export_group("Running")
@export var max_speed := 2250.0           
@export var acceleration := 4550.0
@export var autoDeceleration := 1300.0

@export_group("Jump")
@export var allowDoubleJump := true
@export var jumpForce := 4000.0
@export var maxSpeedInAir := 400
@export var airAcceleration := 75.0
@export var autoAirDeceleration := 35.0

@export_group("La Physics")
@export var gravitationalConstant = 150.0
@export var gravitationalBoostFactorWhenFalling = 1.2



var used_double_Jump = !allowDoubleJump
var is_grounded = true
var previous_direction = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func handleMovement(player: Character) -> void:
	if player.is_on_floor():
		is_grounded = true
		used_double_Jump = !allowDoubleJump
	else:
		is_grounded = false
	
	_simulate_gravity(player)
	
	
	
func _movement_on_ground(player: Character, direction: int) -> void:
	if direction:
		player.velocity.x =  move_toward(player.velocity.x, direction * max_speed, acceleration)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, autoDeceleration)


func _movement_in_air(player: Character, direction: int) -> void:
	if direction:
		if abs(player.velocity.x) > maxSpeedInAir && player.velocity.x * direction > 0:
			pass
			# do Nothing
		else:
			player.velocity.x =  move_toward(player.velocity.x, direction * maxSpeedInAir, airAcceleration)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, autoAirDeceleration)


		

func _simulate_gravity(player: Character) -> void:
	if player.is_on_floor():
		return
	
	if player.velocity.y > 0:
		player.velocity.y += gravitationalConstant*gravitationalBoostFactorWhenFalling
	else:
		player.velocity.y += gravitationalConstant
		
	
	
