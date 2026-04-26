extends Node

@onready var player: Player = $Player
@onready var enemy: Enemy = $Enemy
@onready var evolution_select = $EvolutionSelect

var player_spawn: Vector2
var enemy_spawn: Vector2

func _ready() -> void:	
	player_spawn = player.global_position
	enemy_spawn = enemy.global_position
	display_evolution_select()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://src/scenes/MainMenu.tscn")

func display_evolution_select() -> void:
	enemy.set_enabled(false)
	player.set_enabled(false)
	evolution_select.init_evolution_boxes()
	evolution_select.display()

func reset_game() -> void:
	player.reset()
	enemy.reset()
	
	# remove active bullets and Polen
	remove_nodes_of_group("bullets")
	remove_nodes_of_group("Polen")
	
	player.global_position = player_spawn
	enemy.global_position = enemy_spawn

func remove_nodes_of_group(group_name: String) -> void:
	var nodes: Array[Node] = get_tree().get_nodes_in_group(group_name);
	print("Removing %s nodes in group %s" % [str(nodes.size()), group_name])
	for node in nodes:
		if !node.is_queued_for_deletion():
			node.queue_free()

func _on_player_die(_character: Character) -> void:
	print("Player died")
	reset_game()
	display_evolution_select()


func _on_enemy_die(_character: Character) -> void:
	print("Enemy died")
	enemy.select_random_evolution()
	reset_game()

func _on_evolution_selected(_evolution: int) -> void:
	evolution_select.visible = false
	await get_tree().create_timer(0.1).timeout
	enemy.set_enabled(true)
	player.set_enabled(true)
