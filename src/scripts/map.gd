extends Node2D

@onready var player: Player = $Player

func _ready() -> void:
	player.apply_evolution_effects(Evolutions.Evolution.PISTOL_BULLET_SIZE)
	player.apply_evolution_effects(Evolutions.Evolution.PISTOL_BULLET_SIZE)
	player.apply_evolution_effects(Evolutions.Evolution.PISTOL_BULLET_SIZE)
	player.apply_evolution_effects(Evolutions.Evolution.PISTOL_BULLET_SIZE)
	player.apply_evolution_effects(Evolutions.Evolution.PISTOL_BULLET_SIZE)
	player.apply_evolution_effects(Evolutions.Evolution.PISTOL_BULLET_SIZE)
	
	$EvolutionSelect.display()
