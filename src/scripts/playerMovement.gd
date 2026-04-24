extends Node

@export_group("Character & Model")
@export var player : CharacterBody2D 
@export var model_container : Node3D 

@export_group("Running")
@export var max_speed := 10.0            
@export var acceleration := 50.0
@export var deceleration := 70.0

@export_group("Jump")
@export var allowDoubleJump := true
@export var jumpForce := 12.0
@export var airAcceleration := 20.0
@export var airDeceleration := 10.0

@export_group("La Physics")
@export var gravitationalConstant = 9.81

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	_simulate_gravity(delta)
	
	player.move_and_slide()
	
	
func _simulate_gravity(delta: float) -> void:
	player.velocity += gravitationalConstant*delta*Vector2.DOWN
