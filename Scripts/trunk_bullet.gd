extends Sprite2D

var direction = -1
var speed = 4.0

func _ready():
	if direction==1:
		$TerrainCast.rotation_degrees = 180 

func _physics_process(_delta: float) -> void:
	if not $TerrainCast.is_colliding():
		position.x += direction * speed
		if direction==-1:
			flip_h = false 
		else:
			flip_h = true 
	else:
		queue_free.call_deferred()
