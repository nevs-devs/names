extends Spatial

signal user_selected(node)

const SIZE_FACTOR = 0.1
var _name = ""
var _user_selected
var _camera_to_self = null
var _num_edges = 0

func _ready():
	$Cube/Area.connect("input_event", self, "_on_input_event")
	var s = sqrt(_num_edges * SIZE_FACTOR)
	$Cube.transform = $Cube.transform.scaled(Vector3(s, s, s))
func _on_input_event(_camera, event, click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		emit_signal("user_selected", self)

func change_text(text: String) -> void:
	$Viewport/GUI/Label.text = text
	_name = text

func set_color(color):
	$Cube.get_surface_material(0).albedo_color = color

func _process(delta: float) -> void:
	var cam_pos = $"/root/Main/Camera".translation
	cam_pos.y = translation.y
	$Cube.look_at(cam_pos, Vector3.UP)
	$Cube.rotate(Vector3.UP, deg2rad(180))
