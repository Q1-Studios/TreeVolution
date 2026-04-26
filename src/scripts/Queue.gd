class_name Queue
extends RefCounted

var _head: QueueNode
var _tail: QueueNode
var _size: int


func _init() -> void:
	_head = null
	_tail = null
	_size = 0


func push(data) -> void:
	var new_node = QueueNode.new(data)
	if _head == null:
		_head = new_node
	else:
		_tail.next_node = new_node
	
	_tail = new_node
	_size += 1


func pop():
	if _size == 0:
		return null
		
	var data = _head.data
	_head = _head.next_node
	_size -= 1
	
	if _size == 0:
		_tail = null
		
	return data


func peek():
	if _size == 0:
		return null
	return _head.data


func is_empty() -> bool:
	return _size == 0

func size() -> int:
	return _size

class QueueNode:
	var data
	var next_node

	func _init(new_data) -> void:
		data = new_data
		next_node = null
