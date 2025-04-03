extends AnimatedSprite2D

@export_enum("TOP-DOWN", "LEFT-RIGHT") var type = "TOP-DOWN"
@export var speed = 2.0

@onready var LeftCast = $LeftCast
@onready var RightCast = $RightCast
@onready var TopCast = $TopCast
@onready var BottomCast = $BottomCast

enum {LEFT=-1, RIGHT=1, TOP=-1, DOWN=1, IDLE=0}
var direction 

func _ready():
	if type=="TOP-DOWN":
		LeftCast.enabled = false 
		RightCast.enabled = false 
		direction = TOP
	elif type=="LEFT-RIGHT":
		TopCast.enabled = false 
		BottomCast.enabled = false 
		direction = LEFT 

func _physics_process(_delta: float) -> void:
	if type=="TOP-DOWN":
		if direction==TOP and TopCast.is_colliding():
			play("top_hit")
			direction = IDLE
		elif direction==DOWN and BottomCast.is_colliding():
			play("bottom_hit")
			direction = IDLE
		position.y += direction * speed 
	else:
		if direction==LEFT and LeftCast.is_colliding():
			play("left_hit")
			direction = IDLE
		elif direction==RIGHT and RightCast.is_colliding():
			play("right_hit")
			direction = IDLE
		position.x += direction * speed 

func _on_animation_finished() -> void:
	if animation=="top_hit":
		direction = DOWN
		play("blink")
	elif animation=="bottom_hit":
		direction = TOP 
		play("blink")
	elif animation=="left_hit":
		direction = RIGHT 
		play("blink")
	elif animation=="right_hit":
		direction = LEFT 
		play("blink")
	elif animation=="blink":
		play("idle")
