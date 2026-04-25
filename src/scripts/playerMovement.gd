class_name PlayerMovement
extends MovementController


func handleMovement(player: Character) -> void:
	super(player)

	
	_handle_lateral_movement(player)
	_handle_jump(player)

	player.move_and_slide()


func _handle_lateral_movement(player: Player):
	var direction = _improved_input_getAxis()
	
	if is_grounded:
		_movement_on_ground(player, direction)
	else:
		_movement_in_air(player, direction)


func _handle_jump(player: Player) -> void:
	if Input.is_action_just_pressed("jump"):
		if !is_grounded:
			if used_double_Jump:
				return
			else:
				used_double_Jump = true
			
		
		player.velocity.y = -jumpForce
		
func _improved_input_getAxis() -> int:
	var pos: int = Input.is_action_pressed("moveRight")
	var neg: int = Input.is_action_pressed("moveLeft")
	
	if pos && neg:
		return -previous_direction
	
	previous_direction = pos - neg
	return previous_direction
		
	
