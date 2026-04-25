extends Control

@onready var evolution_box_left = $VBoxContainer/HBoxContainer/EvolutionBox
@onready var evolution_box_center = $VBoxContainer/HBoxContainer/EvolutionBox2
@onready var evolution_box_right = $VBoxContainer/HBoxContainer/EvolutionBox3

signal evolution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_evolution()
	pass

func display_evolution() -> void:
	var all_evolutions = Evolutions.Evolution.values()
	all_evolutions.shuffle()
	var picked_evolutions = all_evolutions.slice(0, 3)
	evolution_box_left.set_evolution_data(Evolutions.get_evolution_data(picked_evolutions[0]))
	evolution_box_center.set_evolution_data(Evolutions.get_evolution_data(picked_evolutions[1]))
	evolution_box_right.set_evolution_data(Evolutions.get_evolution_data(picked_evolutions[2]))


func _on_cool_button_button_up() -> void:
	pass # Replace with function body.
