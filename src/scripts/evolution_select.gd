extends Control

@onready var evolution_box_container = $VBoxContainer/EvoBoxContainer
@onready var confirm_btn = $VBoxContainer/ConfirmBtn

var btn_group: ButtonGroup

signal evolution_selected(evolution: Evolutions.Evolution)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_evolution_boxes()
	pass

func init_evolution_boxes() -> void:
	btn_group = ButtonGroup.new()
	btn_group.pressed.connect(display_confirm_btn)
	
	var all_evolutions = Evolutions.Evolution.values()
	all_evolutions.shuffle()
	
	for index in range(3):
		var evolution: Evolutions.Evolution = all_evolutions[index]
		var evolution_box: EvolutionBox = evolution_box_container.get_child(index)
		evolution_box.set_evolution(evolution)
		evolution_box.button_group = btn_group

func display_confirm_btn(_button: BaseButton) -> void:
	confirm_btn.visible = true
	
func display() -> void:
	init_evolution_boxes()
	visible = true

func _on_cool_button_button_up() -> void:
	var evolution_box: EvolutionBox = btn_group.get_pressed_button()
	var evolution: Evolutions.Evolution = evolution_box.get_evolution()
	print("Selected evolution: " + str(evolution))
	evolution_selected.emit(evolution)
