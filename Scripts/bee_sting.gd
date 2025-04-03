extends Sprite2D

var speed = 4.0

func _physics_process(_delta: float) -> void:
	if not $TerrainCast.is_colliding():
		position.y += speed
	else:
		queue_free.call_deferred()
