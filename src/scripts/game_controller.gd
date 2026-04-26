extends Node

@onready var player: Player = $Player
@onready var enemy: Enemy = $Enemy
@onready var evolution_select = $EvolutionSelect

var player_spawn: Vector2
var enemy_spawn: Vector2

func _ready() -> void:
	player_spawn = player.global_position
	enemy_spawn = enemy.global_position
	evolution_select.display()
	enemy.set_enabled(false)
	player.set_enabled(false)

func _process(_delta: float) -> void:
	pass

func reset_game() -> void:
	player.reset()
	enemy.reset()
	player.global_position = player_spawn
	enemy.global_position = enemy_spawn
	
func _on_player_die(_character: Character) -> void:
	print("Player died")
	reset_game()
	evolution_select.display()


func _on_enemy_die(_character: Character) -> void:
	print("Enemy died")
	enemy.select_random_evolution()
	reset_game()

func _on_evolution_selected(_evolution: int) -> void:
	evolution_select.visible = false
	await get_tree().create_timer(0.1).timeout
	enemy.set_enabled(true)
	player.set_enabled(true)
