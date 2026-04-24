extends Node

@export_group("Character & Model")
@export var player : CharacterBody2D 
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

func _physics_process(delta: float) -> void:
	_simulate_gravity(delta)
	_handleInput(delta)
	
	player.move_and_slide()
	
	
func _handleInput(delta: float) -> void:
	var direction = Input.get_axis("moveLeft", "moveRight")
	if direction:
		player.velocity.x = direction * max_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, autoDeceleration)
	
	if Input.is_action_just_pressed("jump"):
		if player.velocity.y > 0:
			player.velocity.y = 0
		player.velocity.y -= jumpForce
	
	
func _simulate_gravity(delta: float) -> void:
	player.velocity += gravitationalConstant*delta*Vector2.DOWN

func _is_grounded() -> bool:
	return true
