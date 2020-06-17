extends Spatial

const NUM_NODES = 10000
const GraphNodeScene = preload("res://GraphNode.tscn")
const EdgeScene = preload("res://Edge.tscn")
const INIT_DISTANCE = 10.0
var selected_node = null

class NameNode:
	var id
	var name
	
	func _init(id):
		self.id = id

	func _to_string():
		return self.name + ' (' + str(self.id) + ')'

class EdgeNode:
	var source
	var target
	var value

	func _init(source_arg, target_arg):
		randomize()
		self.source = source_arg
		self.target = target_arg

	func _to_string():
		return 'Edge (' + str(self.source) + ' -> ' + str(self.target) + ')'

var name_nodes: Array = []
var edge_nodes: Array = []

func read_xml():
	var data = XMLParser.new()
	data.open('dataset.xml')
	
	var current_name_node = null
	var current_edge_node = null
	while data.read() == 0:
		if data.get_node_type() == data.NODE_ELEMENT:
			if data.get_node_name() == 'node':
				var id = int(data.get_named_attribute_value('id'))
				# print('node: (id: ', id, ')')
				if current_name_node != null:
					print('ERROR: got new name node, before old node was finalized!')
					break
				current_name_node = NameNode.new(id)
				
			if data.get_node_name() == 'edge':
				var source = int(data.get_named_attribute_value('source'))
				var target = int(data.get_named_attribute_value('target'))
				current_edge_node = EdgeNode.new(source, target)
				# print('edge: (', source, ' -> ', target, ')')
		elif data.get_node_type() == data.NODE_TEXT:
			var name = data.get_node_data().strip_edges()
			if name != '':
				if current_name_node != null:
					current_name_node.name = name
					name_nodes.append(current_name_node)
					current_name_node = null
					
				elif current_edge_node != null:
					current_edge_node.value = float(name)
					edge_nodes.append(current_edge_node)
					current_edge_node = null

func _ready():
	read_xml()
	var nodes: Array = []

	var index = 0
	for name_node in name_nodes:
		if index >= NUM_NODES:
			break
		assert(name_node.id == index)
		var graph_node = GraphNodeScene.instance()
		nodes.append(graph_node)
		graph_node.change_text(name_node.name)
		graph_node.translate(Vector3((randf()-0.5)*INIT_DISTANCE, (randf()-0.5)*INIT_DISTANCE, (randf()-0.5)*INIT_DISTANCE))
		graph_node.connect("user_selected", self, "_on_node_selected")
		add_child(graph_node)
		
		index += 1

	for edge_node in edge_nodes:
		if edge_node.source >= NUM_NODES or edge_node.target >= NUM_NODES:
			continue
		var edge = EdgeScene.instance()
		edge.initialize(nodes[edge_node.source], nodes[edge_node.target], 3.0)
		add_child(edge)


func _on_node_selected(node):
	selected_node = node

func _input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed == false:
		selected_node = null

func _process(_delta):
	if selected_node != null:
		var mouse_position = get_viewport().get_mouse_position()
		var distance = selected_node.translation.distance_to($Camera.translation)
		var target_point = $Camera.project_ray_origin(mouse_position) + $Camera.project_ray_normal(mouse_position) * distance
		selected_node.translation = target_point
