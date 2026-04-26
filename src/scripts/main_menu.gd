extends Node2D

func _on_play_button_button_up() -> void:
	get_tree().change_scene_to_file("res://src/scenes/map.tscn")

func _on_cool_button_2_button_up() -> void:
	get_tree().quit(0)
