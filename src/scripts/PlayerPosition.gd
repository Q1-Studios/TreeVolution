class_name PlayerPosition
extends Object

var time: float
var position: Vector2


func _init(pos) -> void:
	time = Time.get_unix_time_from_system()
	position = pos
