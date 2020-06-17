extends Spatial

func _ready():
	pass # Replace with function body.

func change_text(text: String) -> void:
	$Viewport/GUI/Panel/Label.text = text
