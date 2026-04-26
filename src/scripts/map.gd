extends Node2D

@onready var player: Player = $Player
@onready var enemy: Enemy = $Enemy
@onready var evolution_select = $EvolutionSelect

func _ready() -> void:
	evolution_select.display()

func _process(_delta: float) -> void:
	var enabled: bool = !evolution_select.visible
	await get_tree().create_timer(0.1).timeout
	enemy.set_enabled(enabled)
	player.set_enabled(enabled)
