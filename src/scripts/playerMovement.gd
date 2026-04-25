class_name MovementController

extends Node


@export_group("Character & Model")
@export var model_container : Node3D 

@export_group("Running")
@export var max_speed := 450.0            
@export var acceleration := 2250.0
@export var deceleration := 3250.0
@export var autoDeceleration := 900.0

@export_group("Jump")
@export var allowDoubleJump := true
@export var jumpForce := 600.0
@export var airAcceleration := 600.0
@export var airDeceleration := 400.0

@export_group("La Physics")
@export var gravitationalConstant = 9.81


var used_double_Jump = false
var is_grounded = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func handleMovement(player: Player, delta: float) -> void:
	if player.is_on_floor():
		is_grounded = true
		used_double_Jump = false
	else:
		is_grounded = false
	
	_simulate_gravity(player, delta)
	_handle_lateral_movement(player, delta)
	_handle_jump(player, delta)
	
	player.move_and_slide()


func _handle_lateral_movement(player: Player, delta: float):
	var direction = Input.get_axis("moveLeft", "moveRight")
	
	if is_grounded:
		if direction:
			player.velocity.x = direction * move_toward(player.velocity.x, max_speed, acceleration)
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, autoDeceleration)
	
	
	else:
		if direction:
			player.velocity.x = direction * move_toward(player.velocity.x, max_speed, airAcceleration)
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, 0)



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
	if not player.is_on_floor():
		player.velocity += gravitationalConstant*Vector2.DOWN
