extends Node2D
class_name Pollen

var owner_call: Character
var pollen_heal_amount:int
var pollen_damage_enemy_amount:int
var pollen_block_amount: int
var pollen_ability_cooldown:int
var pollen_life_time: int

var pollen_heal_upgrade_count: float
var pollen_damage_upgrade_count: float
var pollen_block_upgrade_count:float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self && pollen_block_amount <= 0:
		self.queue_free()


func _on_bullet_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullets"):
		body.queue_free()
		pollen_block_amount -= 1
