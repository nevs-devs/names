extends Camera

var _dragging: bool = false
var _prev_mouse_pos: Vector2
var _viewport_size: Vector2

export (float, 0.0, 1.0) var sensitivity = 0.5
export (float, 0.0, 0.999, 0.001) var smoothness = 0.5
export (float, 1.0, 10.0, 0.1) var distance = 2.0

var _mouse_offset: Vector2
var _yaw: float = 0.0
var _pitch: float = 0.0
var _target

func _ready() -> void:
	_viewport_size = get_viewport().get_visible_rect().size
	_target = $"/root/Main/Sphere".translation

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			_dragging = event.is_pressed()
		if event.button_index == BUTTON_WHEEL_UP:
			distance = max(distance - 0.1, 0.5)
		if event.button_index == BUTTON_WHEEL_DOWN:
			distance = min(distance + 0.1, 10.0)
	
	if event is InputEventMouseMotion and _dragging:
			_mouse_offset = event.relative

func _process(delta: float) -> void:
	_update_rotation(delta)

func _update_rotation(delta: float) -> void:
	var offset = Vector2()
	offset += _mouse_offset * sensitivity
	_mouse_offset = Vector2.ZERO
	
	_yaw = _yaw * smoothness + offset.x * (1.0 - smoothness)
	_pitch = _pitch * smoothness + offset.y * (1.0 - smoothness)
	
	# set position to target position
	set_translation(_target)
	
	# rotate y axis along the negative yaw
	rotate_y(deg2rad(-_yaw))
	
	# rotates the local transformation around axis, 
	# a unit Vector3, by specified angle in radians.
	rotate_object_local(Vector3(1,0,0), deg2rad(-_pitch))
	
	# translate the view distance on the z axis
	translate(Vector3(0.0, 0.0, distance))
