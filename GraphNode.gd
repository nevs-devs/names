extends Spatial

signal user_selected(node)

var _name = ""
var _user_selected
var _camera_to_self = null

func _ready():
	$Cube/Area.connect("input_event", self, "_on_input_event")

func _on_input_event(_camera, event, click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		emit_signal("user_selected", self)

func change_text(text: String) -> void:
	$Viewport/GUI/Panel/Label.text = text
	_name = text
	
func _process(delta: float) -> void:
	var cam_pos = $"/root/Main/Camera".translation
	cam_pos.y = translation.y
	$Cube.look_at(cam_pos, Vector3.UP)
	$Cube.rotate(Vector3.UP, deg2rad(180))
