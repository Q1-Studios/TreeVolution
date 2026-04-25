class_name EnemyMovement
extends MovementController

@export_group("Graph & character")
@export var G : Graph 
@export var player : Player 

@onready var graph: AStar2D = G.graph
@onready var edges: Dictionary[String, Edge] = G.edgeMap

var edgeNames: Array[String]
	
var path: PackedInt64Array = []

func handleMovement(character: Character) -> void:
	super(character)
	
	if (path.is_empty() 
		or graph.get_closest_point(player.position) != path[-1]
		or graph.get_closest_point(character.position) not in path):
			
		_find_path(character)
		print(path)
		_move_along_path(character)
	
	character.move_and_slide()

func _find_path(character: Character) -> void:
	var startingNode = graph.get_closest_point(character.position)
	var finalNode = graph.get_closest_point(player.position)
	if startingNode == -1 or finalNode == -1:
		print("Can't find a path")
		path = []
		
	path = graph.get_id_path(startingNode, finalNode)
	
func _move_along_path(character:Character) -> void:
	if path.is_empty():
		return
		
	var nextIndex = path.find(graph.get_closest_point(character.position))
	if (nextIndex == len(path)-1):
		return
		
	var edgeName = "%s-%s"%[path[nextIndex], path[nextIndex+1]]
	var edgeNameReverse = "%s-%s"%[path[nextIndex+1], path[nextIndex]]
	
	var nextEdge: Edge
	edgeNames = edges.keys()
	if edgeName in edgeNames:
		nextEdge = edges[edgeName]
	elif edgeNameReverse in edgeNames:
		nextEdge = edges[edgeNameReverse]
	else:
		assert(false, "Edge does not exists, something went horribly wrong")
	
	
	#_handle_lateral_movement(character, delta)
	#_handle_jump(character, delta)

func move_to_next_point(edgeToTraverse: Edge, edgeStartIndex: int, edgeEndIndex: int) -> void:
	pass


func _handle_lateral_movement(character: Character):
	var direction = _improved_input_getAxis()
	
	if is_grounded:
		_movement_on_ground(character, direction)
	else:
		_movement_in_air(character, direction)


func _handle_jump(character: Character) -> void:
	if Input.is_action_just_pressed("jump"):
		if !is_grounded:
			if used_double_Jump:
				return
			else:
				used_double_Jump = true
			
		
		character.velocity.y = -jumpForce
		
func _improved_input_getAxis() -> int:
	var pos: int = Input.is_action_pressed("moveRight")
	var neg: int = Input.is_action_pressed("moveLeft")
	
	if pos && neg:
		return -previous_direction
	
	previous_direction = pos - neg
	return previous_direction
		
