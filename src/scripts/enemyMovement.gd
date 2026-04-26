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
@export var move_randomly_to_neighbor_node_on_same_floor := false
@export var same_floor_delta_y := 10.0
@export var randomize_weights := false
@export var lineup_probability := 0.2
@export var lineup_waiting_time := 0.5

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

var previousGoalNode: int
var previousSelectedNode: int
var previousNodeId: int = -1
var currentPathIndex = 0
var rng = RandomNumberGenerator.new()
var lineupTimer = 0.0

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
		if currentPathIndex > path.size() -1:
			_find_path(character)
			currentPathIndex = 0
		if path.size() > currentPathIndex + 1 and lineupTimer <= 0:
			_setup_next_edge(character, path[currentPathIndex], path[currentPathIndex + 1])
			currentPathIndex += 1
		else:
			_handle_lateral_movement(character, 0)
				
	if is_traversing and lineupTimer <= 0:
		move_to_next_point(character)
	
	character.move_and_slide()

func _find_path(character: Character) -> void:
	var startingNode = graph.get_closest_point(character.position)
	var goalNode = graph.get_closest_point(positionBuffer.peek().position)
	var possibleNodes = graph.get_point_connections(goalNode)
	var applicableNodes = []
	applicableNodes.push_back(goalNode)
	
	for node in possibleNodes:
		if abs(graph.get_point_position(goalNode)[1] - graph.get_point_position(node)[1]) < same_floor_delta_y:
			applicableNodes.push_back(node)
	
	var finalNode: int
	if move_randomly_to_neighbor_node_on_same_floor:
		if goalNode != previousGoalNode:
			finalNode = applicableNodes.pick_random()
		else:
			finalNode = previousSelectedNode
	else:
		finalNode = goalNode
	
	if startingNode == -1 or finalNode == -1:
		print("Can't find a path")
		path = []
		return
	
	previousSelectedNode = finalNode
	previousGoalNode = goalNode		
	
	if randomize_weights:
		for id in graph.get_point_ids():
			var w = rng.randfn(500, 200)
			if w < 500:
				w = 500 - w
			else:
				w = 1500 - w
			graph.set_point_weight_scale(id, w)
		
		if previousNodeId != -1 and previousNodeId != startingNode:
			graph.set_point_weight_scale(previousNodeId, 10000.0) 
		path = graph.get_id_path(startingNode, finalNode)
		for id in graph.get_point_ids():
			graph.set_point_weight_scale(id, 1.0)
	else:
		path = graph.get_id_path(startingNode, finalNode)
	

func _setup_next_edge(character: Character, start_id: int, end_id: int) -> void:
	previousNodeId = start_id 
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
	
	if dist_x <= arrival_distance_x  and is_grounded: #and dist_y <= arrival_distance_y
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
