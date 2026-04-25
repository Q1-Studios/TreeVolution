extends Button

@onready var broken_state: Control = $Broken
@onready var fixet_state: Control = $Fixet

@export var evolution_data: EvolutionData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func set_evolution_data(data: EvolutionData) -> void:
	evolution_data = data
	_on_button_toggled(button_pressed)
		
func update_information(parent: Control) -> void:
	if !evolution_data:
		return
	
	var title_node: Label = parent.get_node("Title")
	var description_node: Label = parent.get_node("Description")
	var icon_node: TextureRect = parent.get_node("Icon")
	
	title_node.text = evolution_data.readable_name
	description_node.text = evolution_data.description
	icon_node.texture = evolution_data.icon 
	

func _on_button_toggled(is_active: bool) -> void:
	fixet_state.visible = !is_active
	broken_state.visible = is_active
	
	var active_state: Control = fixet_state if !is_active else broken_state
	update_information(active_state)
	
	
