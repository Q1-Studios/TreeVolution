class_name OverlayCamera
extends Camera2D

@export var main_camera: Camera2D 

func _ready() -> void:
	var parent_overlay = get_parent()

	if parent_overlay is CanvasItem:
		parent_overlay.visibility_changed.connect(_on_overlay_visibility_changed)

func _on_overlay_visibility_changed() -> void:
	var parent_overlay = get_parent()
	
	if parent_overlay.visible:
		make_current()
	else:
		if is_instance_valid(main_camera):
			main_camera.make_current()
