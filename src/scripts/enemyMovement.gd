class_name EnemyMovement
extends MovementController

@export_group("Graph & character")
@export var G : Graph 
@export var player : Player 

@export_group("AI Parameters")
@export var arrival_distance_x := 25.0
@export var time_to_build_speed_before_jump := 0.05
@export var reaction_delay := 0.0
@export var sampling_time := 1.0
@export var lineup_probability := 0.2
@export var lineup_waiting_time := 0.5
@export var probability_to_go_somewhere_random = 0.0



@onready var graph: AStar2D = G.graph
@onready var edges: Dictionary[String, Edge] = G.edgeMap

var edgeNames: Array[String]
var path: PackedInt64Array = []

var is_traversing: bool = false
var current_target_pos: Vector2
var active_edge: Edge = null

var jump_phase: int = 0 # 0: initial jump, 1: double jump, 2: done jumping
var edge_timer: float = 0.0
var should_jump: bool = false
var should_double_jump: bool = false

var positionBuffer:Queue = Queue.new()

var rng = RandomNumberGenerator.new()
var lineupTimer = 0.0
var headingRandom = false
var randomNode = -1

func _ready() -> void:
	airAcceleration = 1000 # cheating Enemy

func handleMovement(character: Character) -> void:
	super(character)
		
	var now = Time.get_unix_time_from_system()
	if positionBuffer.is_empty() or positionBuffer.peek().time < now - sampling_time:
		positionBuffer.push(PlayerPosition.new(player.position))
	
	if positionBuffer.peek().time < now - reaction_delay:
		if positionBuffer.size() > 1:
			positionBuffer.pop()
	
	if lineupTimer > 0:
		lineupTimer -= character.get_physics_process_delta_time()
		
	if not is_traversing:
		_find_path(character)
		if path.size() > 1:
			_setup_next_edge(character, path[0], path[1])
		elif !headingRandom and path.size() == 1:
			var posDiff = player.position.x - character.position.x
			if posDiff < arrival_distance_x: 
				posDiff = 0
			_handle_lateral_movement(character, sign(posDiff))
		else:
			_handle_lateral_movement(character, 0)
			headingRandom = false
			randomNode = -1
				
	if is_traversing and lineupTimer <= 0:
		move_to_next_point(character)
	
	character.move_and_slide()

func _find_path(character: Character) -> void:
	var startingNode = graph.get_closest_point(character.position)
	var goalNode = graph.get_closest_point(positionBuffer.peek().position)
	
	if headingRandom:
		goalNode = randomNode
	elif rng.randf() < probability_to_go_somewhere_random && startingNode != goalNode:
		goalNode = graph.get_point_ids()[rng.randi_range(0, graph.get_point_count()-1)]
		

	if startingNode == -1 or goalNode == -1:
		print("Can't find a path")
		path = []
		return
	
	path = graph.get_id_path(startingNode, goalNode)
	

func _setup_next_edge(character: Character, start_id: int, end_id: int) -> void:
	current_target_pos = graph.get_point_position(end_id)
	
	var edgeName = "%s-%s" % [start_id, end_id]
	var edgeNameReverse = "%s-%s" % [end_id, start_id]
	edgeNames = edges.keys()
	if edgeName in edgeNames:
		active_edge = edges[edgeName]
	elif edgeNameReverse in edgeNames:
		active_edge = edges[edgeNameReverse]
	else:
		print("Edge does not exists, something went horribly wrong")
		active_edge = null 
		
	# reset state variables
	is_traversing = true
	jump_phase = 0
	edge_timer = 0.0
	should_jump = false
	should_double_jump = false
	
	if active_edge:
		var is_moving_down = current_target_pos.y > character.position.y
		
		if not is_moving_down or active_edge.jumpOnDown:
			should_jump = active_edge.jump or active_edge.doubleJump
			should_double_jump = active_edge.doubleJump


func move_to_next_point(character: Character) -> void:
	var delta = character.get_physics_process_delta_time()
	
	var direction = sign(current_target_pos.x - character.position.x)
	_handle_lateral_movement(character, direction)
	
	if should_jump and jump_phase == 0:
		edge_timer += delta
		if edge_timer >= time_to_build_speed_before_jump:
			_handle_jump(character)
			jump_phase = 1 
			edge_timer = 0.0 
			
	elif should_double_jump and jump_phase == 1:
		edge_timer += delta
		if edge_timer >= active_edge.timeTillDoubleJump:
			_handle_jump(character)
			jump_phase = 2
			
	var dist_x = abs(character.position.x - current_target_pos.x)
	
	if dist_x <= arrival_distance_x  and is_grounded and character.velocity.length() < acceleration: #and dist_y <= arrival_distance_y
		is_traversing = false
		if rng.randf() < lineup_probability:
			lineupTimer = lineup_waiting_time


func _handle_lateral_movement(character: Character, direction: int):
	if is_grounded:
		_movement_on_ground(character, direction)
	else:
		_movement_in_air(character, direction)


func _handle_jump(character: Character) -> void:
	if !is_grounded:
		if used_double_Jump:
			return
		else:
			used_double_Jump = true
			
		
	character.velocity.y = -jumpForce
