extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var health = 10
var pollen_attributes = {"Damage": 1, "Healing": 1, "Blocking": false}
var pollen_obj

func _ready():
	pollen_obj = get_node("")
	pass
	



func _on_pollen_start_effect() -> void:
	print("yes")


func _on_pollen_stop_effect() -> void:
	print("no")
