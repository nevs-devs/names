extends Spatial

var _nodeA: Spatial
var _nodeB: Spatial
var _val: float = 0.0

func initialize(nodeA: Spatial, nodeB: Spatial, val: float) -> void:
	_nodeA = nodeA
	_nodeB = nodeB
	_val = val
	
func _process(delta: float) -> void:
	var dist = _nodeA.translation.distance_to(_nodeB.translation)
	print(dist)
