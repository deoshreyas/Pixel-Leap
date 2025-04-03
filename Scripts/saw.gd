extends Path2D

enum ANIMATION_TYPE {
	LOOP, 
	BOUNCE
}

@export var AnimationType : ANIMATION_TYPE
@export var DrawLine : bool = true 

func _ready():
	if DrawLine:
		$Line2D.points = curve.get_baked_points()
	match AnimationType:
		ANIMATION_TYPE.LOOP: $AnimationPlayer.play("Loop")
		ANIMATION_TYPE.BOUNCE: $AnimationPlayer.play("Bounce")
