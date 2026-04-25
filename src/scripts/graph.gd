class_name Graph
extends Node2D

@export var V: Node2D
@export var E: Node2D

var vertexList:Array[Node2D] = []
var edgeList:Array[Edge] = []
var edgeMap: Dictionary[String, Edge] = {}
var graph = AStar2D.new()


func _ready() -> void:
	
	_get_vertices()
	_get_edges()
	_build_graph()
	
func _get_vertices():
	for vertex: Node2D in V.get_children():
		if !vertex.is_in_group("Vertices"):
			print("please fix your vertex list")
			continue
		
		vertexList.append(vertex)
	
		
func _get_edges():
	for edgeholder: Node2D in E.get_children(true):
		if edgeholder is Line2D and edgeholder.is_in_group("Edges"):
			print("bro why")
			edgeList.append(edgeholder)
			
			
		for edge in edgeholder.get_children():
			if !edge.is_in_group("Edges"):
				print("please fix your edge list")
				continue
		
			edgeList.append(edge)
	
			
func _build_graph() -> void:
	for i in len(vertexList):
		graph.add_point(i, vertexList[i].position, 1.0)
	
	for edge in edgeList:
		var closestPointIds: Array[int] = []
		var edgePoints = edge.points
		var bidirectional = true
		assert(len(edgePoints) == 2, "An Edge (in this case %s) has 2 Points not more not less you idiot "%edge.name)
		
		for point in edgePoints:
			closestPointIds.append(graph.get_closest_point(point))
		
		if edge.onlyDown:
			bidirectional = false
			if edge.points[0][1] > edge.points[1][1]:
				var tempId = closestPointIds[0]
				var tempPoint = edge.points[0]
				closestPointIds[0] = closestPointIds[1]
				edge.points[0] = edge.points[1]
				closestPointIds[1] = tempId
				edge.points[1] =tempPoint
			
			
		# Does not work since (unidirectional, graph.connect_points(closestPointIds[0], closestPointIds[1])
		graph.connect_points(closestPointIds[0], closestPointIds[1], bidirectional)
		edgeMap["%s-%s"%[str(closestPointIds[0]),str(closestPointIds[1])]] = edge
	
		
 		
	
