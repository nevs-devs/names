extends Spatial

const NUM_NODES = 50
const GraphNodeScene = preload("res://GraphNode.tscn")
const EdgeScene = preload("res://Edge.tscn")
const INIT_DISTANCE = 10.0
var selected_node = null
var desired_distance: float = 20.0
var screen_size: Vector2
var nodes: Array = []

class NameNode:
	var id
	var name
	var num_edges
	
	func _init(id):
		self.id = id
		self.num_edges = 0

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
	for edge_node in edge_nodes:
		var source_node = name_nodes[edge_node.source]
		var target_node = name_nodes[edge_node.target]
		source_node.num_edges += 1
		target_node.num_edges += 1

func _ready():
	read_xml()

	var index = 0
	for name_node in name_nodes:
		if index >= NUM_NODES:
			break
		assert(name_node.id == index)
		var graph_node = GraphNodeScene.instance()
		nodes.append(graph_node)
		graph_node.change_text(name_node.name)
		graph_node._num_edges = name_node.num_edges
		graph_node.translate(Vector3((randf()-0.5)*INIT_DISTANCE, (randf()-0.5)*INIT_DISTANCE, (randf()-0.5)*INIT_DISTANCE))
		graph_node.connect("user_selected", self, "_on_node_selected")
		add_child(graph_node)
		
		index += 1

	for edge_node in edge_nodes:
		if edge_node.source >= NUM_NODES or edge_node.target >= NUM_NODES:
			continue
		var edge = EdgeScene.instance()
		var source_node = nodes[edge_node.source]
		var target_node = nodes[edge_node.target]
		edge.initialize(source_node, target_node, edge_node.value)
		add_child(edge)
		
		$UI/DistSlider.value = desired_distance

	$UI/Searchbar.connect("text_changed", self, '_on_search')


func _on_search(value):
	search_name(value)


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
	
	if get_viewport().get_visible_rect().size != screen_size:
		screen_size = get_viewport().get_visible_rect().size
		$UI.position.x = screen_size.x - 250
		$UI.position.y = screen_size.y - 100

func _on_DistSlider_value_changed(value):
	desired_distance = value
	$UI/DistVal.text = str(value)

func search_name(name):
	for node in nodes:
		var matches = node._name.to_lower().begins_with(name.to_lower())
		if name == '':
			matches = false
		if matches:
			node.set_color(Color.red)
		else:
			node.set_color(Color.white)
