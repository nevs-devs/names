extends Spatial

export(float) var desired_distance = 4.0
 
var _nodeA: Spatial
var _nodeB: Spatial
var _val: float = 0.0

func initialize(nodeA: Spatial, nodeB: Spatial, val: float) -> void:
	_nodeA = nodeA
	_nodeB = nodeB
	_val = val
	
func _physics_process(delta: float) -> void:
	var center: Vector3 = (_nodeA.translation + _nodeB.translation) / 2
	translation = center
	look_at(_nodeA.translation, Vector3.UP)
	var dist = _nodeA.translation.distance_to(_nodeB.translation)
	
	var diff: float = dist - desired_distance
	if abs(diff) > 0.1:
		var dir = _nodeA.translation.direction_to(_nodeB.translation)
		_nodeA.translate(dir * (diff / 2.0) * 0.2 * delta)
		_nodeB.translate(-dir * (diff / 2.0) * 0.2 * delta)
	
	scale = Vector3(1, 1, dist)
