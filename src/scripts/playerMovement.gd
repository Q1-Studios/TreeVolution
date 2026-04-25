class_name MovementController

extends Node


@export_group("Character & Model")
@export var model_container : Node3D 

@export_group("Running")
@export var max_speed := 100.0            
@export var acceleration := 500.0
@export var deceleration := 700.0
@export var autoDeceleration := 200.0

@export_group("Jump")
@export var allowDoubleJump := true
@export var jumpForce := 300.0
@export var airAcceleration := 200.0
@export var airDeceleration := 100.0

@export_group("La Physics")
@export var gravitationalConstant = 98.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func handleMovement(player: Player, delta: float) -> void:
	_simulate_gravity(player, delta)
	_handle_lateral_movement(player, delta)
	_handle_jump(player, delta)
	
	player.move_and_slide()


func _handle_lateral_movement(player: Player, delta: float):
	var direction = Input.get_axis("moveLeft", "moveRight")
	if direction:
		player.velocity.x = direction * max_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, autoDeceleration)



func _handle_jump(player: Player, delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		if !player.is_on_floor():
			return
			
		if player.velocity.y > 0:
			player.velocity.y = 0
		player.velocity.y -= jumpForce



func _simulate_gravity(player: Player, delta: float) -> void:
	if not player.is_on_floor():
		player.velocity += gravitationalConstant*delta*Vector2.DOWN
