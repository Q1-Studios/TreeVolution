extends Area2D


var can_affect = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func affect_player(player, polen_attributes):
	if !can_affect:
		return
	can_affect = false
	var dictionary_keys = polen_attributes.keys()
	buff_player_damage(player, polen_attributes[dictionary_keys[0]])
	heal_player(player, polen_attributes[dictionary_keys[1]])
	start_effect_cooldown()
	
func start_effect_cooldown():
	await get_tree().create_timer(1.0).timeout
	can_affect = true
	
	
	

func buff_player_damage(player, array):
	if array[0]:
		player.player_health += array[1]
		print("buff dmg")

func heal_player(player, array):
	if array[0]:
		player.player_health += array[1]
		print("heal")
