class_name Player
extends PollenAffected


@onready var pollen_obj = preload("res://src/scenes/Pollen.tscn")

func _ready() -> void:
	health = 100

func _process(delta) -> void:
	spawn_pollen()


func spawn_pollen():
	if Input.is_action_just_pressed("Pollen ability"):
		var player_position = $".".position
		var temp_pollen = pollen_obj.instantiate()
		temp_pollen = create_pollen(temp_pollen)
		get_tree().root.add_child(temp_pollen)
		temp_pollen.global_position = player_position 
		await get_tree().create_timer(pollen_life_time).timeout
		temp_pollen.queue_free()
