extends Node2D
class_name Pollen

var owner_call: Character
var pollen_heal_amount: float
var pollen_damage_enemy_amount: float
var pollen_block_amount: int
var pollen_ability_cooldown: float
var pollen_life_time: float

var pollen_heal_upgrade_count: float = 0
var pollen_damage_upgrade_count: float = 0
var pollen_block_upgrade_count:float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var red = min(1.0, pollen_damage_upgrade_count)
	var green = min(1.0, pollen_heal_upgrade_count)
	var blue = min(1.0, pollen_block_upgrade_count)
	$CPUParticles2D.self_modulate = Color(red, green, blue)
	
	if self && pollen_block_amount <= 0:
		self.queue_free()


func _on_bullet_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullets"):
		body.queue_free()
		pollen_block_amount -= 1
