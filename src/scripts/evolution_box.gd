extends Button
class_name EvolutionBox

@onready var broken_state: Control = $Broken
@onready var fixet_state: Control = $Fixet

@export var evolution: Evolutions.Evolution

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func set_evolution(_evolution: Evolutions.Evolution) -> void:
	evolution = _evolution
	_on_button_toggled(button_pressed)
	
func get_evolution() -> Evolutions.Evolution:
	return evolution
	
func update_information(parent: Control) -> void:
	var evolution_data = Evolutions.get_evolution_data(evolution)
	
	if !evolution_data:
		return
	
	var title_node: Label = parent.get_node("Title")
	var description_node: Label = parent.get_node("Description")
	var icon_node: TextureRect = parent.get_node("Icon")
	
	
	title_node.text = evolution_data.readable_name
	description_node.text = evolution_data.description
	icon_node.texture = evolution_data.icon 
	icon_node.self_modulate = evolution_data.color
	

func _on_button_toggled(is_active: bool) -> void:
	fixet_state.visible = !is_active
	broken_state.visible = is_active
	
	var active_state: Control = fixet_state if !is_active else broken_state
	update_information(active_state)
	
	
