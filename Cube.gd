extends MeshInstance

func _process(delta: float) -> void:
	look_at($"/root/Main/Camera".translation, Vector3.UP)
	print(rotation)
