extends Node2D

enum {LEFT, RIGHT}

var state = RIGHT

@export var speed = 150 
@export var pause_duration = 1 
@export var blink_interval = 0.1

@onready var start_position = global_position 
@onready var raycast_left = $LeftRayCast
@onready var raycast_right = $RightRayCast
@onready var AnimatedSprite = $AnimatedSprite2D

func _ready():
	$Timer.wait_time = blink_interval

func _physics_process(delta: float) -> void:
	match state:
		LEFT: left_state(delta)
		RIGHT: right_state(delta) 
	
func left_state(delta):
	if raycast_left.is_colliding():
		if AnimatedSprite.animation=="left_hit": return 
		AnimatedSprite.play("left_hit")
		await get_tree().create_timer(pause_duration).timeout
		AnimatedSprite.play("idle")
		state = RIGHT
	else:
		position.x -= speed * delta

func right_state(delta):
	if raycast_right.is_colliding():
		if AnimatedSprite.animation=="right_hit": return 
		AnimatedSprite.play("right_hit")
		await get_tree().create_timer(pause_duration).timeout
		AnimatedSprite.play("idle")
		state = LEFT
	else:
		position.x += speed * delta

func _on_timer_timeout() -> void:
	if AnimatedSprite.animation=="idle":
		AnimatedSprite.play("blink")
