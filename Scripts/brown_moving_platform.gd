extends AnimatableBody2D

@export var speed = 1.0

enum {LEFT=-1, RIGHT=1}
var direction = LEFT

var original_x 

func _ready():
	original_x = global_position.x 

func _physics_process(_delta: float) -> void:
	if $PlayerDetectCast.is_colliding() or $PlayerDetectCast2.is_colliding() or $PlayerDetectCast3.is_colliding():
		if $AnimatedSprite2D.animation!="moving":
			$AnimatedSprite2D.play("moving")
		if direction==LEFT and $LeftCast.is_colliding():
			direction = RIGHT
		elif direction==RIGHT and $RightCast.is_colliding():
			direction = LEFT 
		position.x += direction * speed 
	else:
		$AnimatedSprite2D.play("stationary")
