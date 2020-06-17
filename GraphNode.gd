extends Spatial

var velocity = Vector3()
var _name = ""

func _ready():
	$Quad/Area.connect("mouse_entered", self, "_on_mouse_entered")
	$Quad/Area.connect("input_event", self, "_on_input_event")

func _on_mouse_entered():
	print(_name)

func _on_input_event(camera, event, click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton and event.button_index:
		print(event.button_index)

func change_text(text: String) -> void:
	$Viewport/GUI/Panel/Label.text = text
	_name = text
	
func _process(delta: float) -> void:
	var cam_pos = $"/root/Main/Camera".translation
	cam_pos.y = translation.y
	look_at(cam_pos, Vector3.UP)
	translate(velocity)
