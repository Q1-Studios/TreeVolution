extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var btn_group: ButtonGroup = ButtonGroup.new()
	
	for node in get_children():
		if node is Button:
			node.button_group = btn_group
			print(btn_group)
