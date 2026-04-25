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
@export var autoAirDeceleration := 5.0

@export_group("La Physics")
@export var gravitationalConstant = 150.0
@export var gravitationalBoostFactorWhenFalling = 1.2



var used_double_Jump = !allowDoubleJump
var is_grounded = true
var previous_direction = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func handleMovement(player: Player, delta: float) -> void:
	if player.is_on_floor():
		is_grounded = true
		used_double_Jump = !allowDoubleJump
	else:
		is_grounded = false
	
	_handle_lateral_movement(player, delta)
	_handle_jump(player, delta)
	_simulate_gravity(player, delta)
	
	player.move_and_slide()


func _handle_lateral_movement(player: Player, delta: float):
	var direction = _improved_input_getAxis()
	
	if is_grounded:
		_movement_on_ground(player, direction)
	else:
		_movement_in_air(player, direction)


func _movement_on_ground(player: Player, direction: int) -> void:
	if direction:
		player.velocity.x =  move_toward(player.velocity.x, direction * max_speed, acceleration)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, autoDeceleration)


func _movement_in_air(player: Player, direction: int) -> void:
	if direction:
		if abs(player.velocity.x) > maxSpeedInAir && player.velocity.x * direction > 0:
			pass
			# do Nothing
		else:
			player.velocity.x =  move_toward(player.velocity.x, direction * maxSpeedInAir, airAcceleration)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, autoAirDeceleration)




func _handle_jump(player: Player, delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		if !is_grounded:
			if used_double_Jump:
				return
			else:
				used_double_Jump = true
			
		if player.velocity.y > 0:
			player.velocity.y = 0
		player.velocity.y -= jumpForce
		

func _simulate_gravity(player: Player, delta: float) -> void:
	if player.is_on_floor():
		return
	
	if player.velocity.y > 0:
		player.velocity.y += gravitationalConstant*gravitationalBoostFactorWhenFalling
	else:
		player.velocity.y += gravitationalConstant
		
	
	
	
	


func _improved_input_getAxis() -> int:
	var pos: int = Input.is_action_pressed("moveRight")
	var neg: int = Input.is_action_pressed("moveLeft")
	
	if pos && neg:
		return -previous_direction
	
	previous_direction = pos - neg
	return previous_direction
		
	
