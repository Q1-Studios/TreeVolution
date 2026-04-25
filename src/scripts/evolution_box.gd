extends Button

@export var label: String
@export var texture: Texture2D

@onready var broken_state = $Broken
@onready var fixet_state = $Fixet

@onready var label_path = $Fixet/Label
@onready var icon_path = $Fixet/Icon

@onready var label_broken_path = $Broken/Label
@onready var icon_broken_path = $Broken/Icon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(str(button_group))
	set_label_text(label)
	set_icon(texture)
	_on_button_toggled(button_pressed)
		
func set_label_text(value: String) -> void:
	label_path.text = value
	label_broken_path.text = value

func set_icon(_texture: Texture2D) -> void:
	icon_path.texture = _texture
	icon_broken_path.texture = _texture
	

func _on_button_toggled(is_active: bool) -> void:
	fixet_state.visible = !is_active
	broken_state.visible = is_active
