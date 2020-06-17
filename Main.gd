extends Spatial

const GraphNodeScene = preload("res://GraphNode.tscn")
const INIT_DISTANCE = 10.0

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

	var index = 0
	for name_node in name_nodes:
		if index > 20:
			break
		var graph_node = GraphNodeScene.instance()
		graph_node.change_text(name_node.name)
		graph_node.translate(Vector3((randf()-0.5)*INIT_DISTANCE, (randf()-0.5)*INIT_DISTANCE, (randf()-0.5)*INIT_DISTANCE))
		add_child(graph_node)
		
		index += 1

	# print(name_nodes)
	# print(edge_nodes)
