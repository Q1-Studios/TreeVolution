class_name Player
extends Character


@onready var pollen_obj = preload("res://src/scenes/Pollen.tscn")
var can_spawn_pollen: bool = true

var max_time: float = 0.5
var timer: float = pollen_life_time

func _ready() -> void:
	health = 100
	
func _physics_process(_delta: float) -> void:
	_handle_gun()

func _process(delta) -> void:
	timer -= delta
	spawn_pollen()
	print(timer)
	if(timer <= 0 && !can_spawn_pollen):
		can_spawn_pollen=true

func _handle_gun() -> void:
	var direction = get_global_mouse_position() - gun.global_position
	gun.rotate_weapon(direction)
	
	if Input.is_action_pressed("shoot"):
		gun.shoot(direction)

func spawn_pollen():
	if Input.is_action_just_pressed("Pollen ability") && can_spawn_pollen:
		timer = pollen_summon_cooldown
		can_spawn_pollen = false
		var player_position = $".".position
		var temp_pollen = pollen_obj.instantiate()
		temp_pollen = create_pollen(temp_pollen)
		get_tree().root.add_child(temp_pollen)
		temp_pollen.global_position = player_position 
		await get_tree().create_timer(pollen_life_time).timeout
		if temp_pollen:
			temp_pollen.queue_free()
			start_pollen_cooldown()
		
func start_pollen_cooldown():
	print("recieve")
	timer = max_time
	can_spawn_pollen = false

	
