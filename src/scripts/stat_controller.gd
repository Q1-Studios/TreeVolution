class_name StatController

extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func bullet_damage(player, body):
	if body.is_in_group("bullets"):
		var bullet_damage: float = body.damage
		print("Collided with bullet, took %s damage " % str(bullet_damage))
		player.player_health -= bullet_damage

func polen_heal(player, area, healing_array):
	while area && area.is_in_group("Polen"):
		if (!area.is_in_group("Polen")):
			return
		polen_healing(player, healing_array)
		await get_tree().create_timer(1).timeout
		
func polen_buff_damage(player, area, damage_array):
	while area.is_in_group("Polen"):
		polen_damage_buff(player, damage_array)
		await get_tree().create_timer(1).timeout

func polen_healing(player, healing_array):
	var new_health
	if(healing_array[0]):
		new_health = player.player_health + healing_array[1]
		player.player_health = min(new_health, player.PLAYER_MAX_HEALTH)
	print("Healing Health: ", player.player_health)

func polen_damage_buff(player, damage_buff_array):
	var new_damage = player.player_damage + damage_buff_array[1]
	if(damage_buff_array[0]):
		player.player_damage = new_damage
	print("Damage while in polen: ", player.player_damage)
