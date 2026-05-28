extends Node2D

@export var web_restart_info: ColorRect

func _on_play_button_button_up() -> void:
	get_tree().change_scene_to_file("res://src/scenes/map.tscn")

func _on_cool_button_2_button_up() -> void:
	if OS.get_name() == "Web":
		web_restart_info.show()
	get_tree().quit(0)
