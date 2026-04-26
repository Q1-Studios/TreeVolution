class_name SmashCamera
extends Camera2D

@export var player: Node2D
@export var enemy: Node2D

@export_group("Camera Settings")
@export var margin := Vector2(150, 150) 
@export var max_zoom_in := 0.25 
@export var max_zoom_out := 0.01
@export var tracking_speed := 4.0

func _process(delta: float) -> void:
	if not is_instance_valid(player) or not is_instance_valid(enemy):
		return
		
	var midpoint = (player.global_position + enemy.global_position) / 2.0
	
	global_position = global_position.lerp(midpoint, tracking_speed * delta)
	
	var distance_x = abs(player.global_position.x - enemy.global_position.x)
	var distance_y = abs(player.global_position.y - enemy.global_position.y)
	
	var viewport_size = get_viewport_rect().size
	
	var required_width = distance_x + (margin.x * 2.0)
	var required_height = distance_y + (margin.y * 2.0)
	
	required_width = max(required_width, 1.0)
	required_height = max(required_height, 1.0)

	var zoom_x = viewport_size.x / required_width
	var zoom_y = viewport_size.y / required_height
	
	var target_zoom_scalar = min(zoom_x, zoom_y)
	
	target_zoom_scalar = clamp(target_zoom_scalar, max_zoom_out, max_zoom_in)
	
	var target_zoom = Vector2(target_zoom_scalar, target_zoom_scalar)
	zoom = zoom.lerp(target_zoom, tracking_speed * delta)
