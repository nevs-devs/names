extends Spatial

func _ready():
	pass # Replace with function body.

func change_text(text: String) -> void:
	$Viewport/GUI/Panel/Label.text = text
	
func _process(delta: float) -> void:
	var cam_pos = $"/root/Main/Camera".translation
	cam_pos.y = translation.y
	look_at(cam_pos, Vector3.UP)
