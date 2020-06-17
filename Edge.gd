extends Spatial

var _nodeA: Spatial
var _nodeB: Spatial
var _val: float = 0.0

func initialize(nodeA: Spatial, nodeB: Spatial, val: float) -> void:
	_nodeA = nodeA
	_nodeB = nodeB
	_val = val
	
func _process(delta: float) -> void:
	var center: Vector3 = (_nodeA.translation + _nodeB.translation) / 2
	translation = center
	look_at(_nodeA.translation, Vector3.UP)
	var dist = _nodeA.translation.distance_to(_nodeB.translation)
	scale = Vector3(1, 1, dist)
	#print(dist)
