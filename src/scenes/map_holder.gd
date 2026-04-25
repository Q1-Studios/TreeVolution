extends Node2D

const icon = preload("res://src/scenes/icon.tscn")
var graph

func _ready() -> void:
	graph = AStar2D.new()
	
