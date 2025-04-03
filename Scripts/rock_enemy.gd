extends Node2D

enum {FALL, RISE}

var state = FALL

@export var speed = 150 
@export var pause_duration = 1 
@export var blink_interval = 0.1

@onready var start_position = global_position 
@onready var raycast_down = $DownRayCast
@onready var raycast_up = $UpRayCast
@onready var AnimatedSprite = $AnimatedSprite2D

func _ready():
	$Timer.wait_time = blink_interval

func _physics_process(delta: float) -> void:
	match state:
		FALL: fall_state(delta)
		RISE: rise_state(delta) 
	
func fall_state(delta):
	if raycast_down.is_colliding():
		if AnimatedSprite.animation=="bottom_hit": return 
		AnimatedSprite.play("bottom_hit")
		await get_tree().create_timer(pause_duration).timeout
		AnimatedSprite.play("idle")
		state = RISE
	else:
		position.y += speed * delta

func rise_state(delta):
	if raycast_up.is_colliding():
		if AnimatedSprite.animation=="top_hit": return 
		AnimatedSprite.play("top_hit")
		await get_tree().create_timer(pause_duration).timeout
		AnimatedSprite.play("idle")
		state = FALL  
	else:
		position.y -= speed * delta

func _on_timer_timeout() -> void:
	if AnimatedSprite.animation=="idle":
		AnimatedSprite.play("blink")
