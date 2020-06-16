extends Spatial

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

var name_nodes = []
var edge_nodes = []

func _ready():
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

	print(name_nodes)
	print(edge_nodes)
