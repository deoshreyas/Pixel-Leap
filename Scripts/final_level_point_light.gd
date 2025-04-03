extends PointLight2D

func _physics_process(_delta: float) -> void:
	if global_position.y>510:
		visible = true 
	else:
		visible = false 
