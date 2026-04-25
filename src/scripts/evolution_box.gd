extends Control


@export var label: String
@export var texture: Texture2D

@onready var label_path = $PanelContainer/VBoxContainer/Label
@onready var texture_path = $PanelContainer/VBoxContainer/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_text(label)
	set_icon(texture)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_text(value: String) -> void:
	label_path.text = value

func set_icon(_texture: Texture2D) -> void:
	texture_path.texture = _texture
