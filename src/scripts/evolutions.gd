extends Node

enum Evolution {
	PLAYER_HEALTH,
	PLAYER_SPEED,
	PLAYER_JUMP,
	PLAYER_POLLEN_COOLDOWN,
	POLLEN_DAMAGE,
	POLLEN_BLOCK,
	POLLEN_HEAL,
	PISTOL_BULLET_SIZE,
	PISTOL_BULLET_SPEED,
	PISTOL_BULLET_DAMAGE,
	PISTOL_BULLET_BOUNCES,
	PISTOL_BULLET_COUNT
}

@export var EVO_DICT: Dictionary[Evolutions.Evolution, EvolutionData] = {}

func get_evolution_data(evo: Evolutions.Evolution) -> EvolutionData:
	return EVO_DICT[evo]
