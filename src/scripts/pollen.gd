extends Node2D
class_name Pollen

var owner_call: PollenAffected
var pollen_heal_amount:int = 1
var pollen_damage_enemy_amount:int = 5
var pollen_ability_cooldown:int = 10
var pollen_life_time: int = 10

var pollen_heal_upgrade_count: float = 1
var pollen_damage_upgrade_count: float = 3
var pollen_blocking_unlock:float = min(pollen_heal_upgrade_count, pollen_damage_upgrade_count)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.modulate = Color(pollen_damage_upgrade_count, pollen_heal_upgrade_count, pollen_blocking_unlock)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_bullet_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullets"):
		body.queue_free()
