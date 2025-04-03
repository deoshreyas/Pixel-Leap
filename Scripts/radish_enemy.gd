extends AnimatedSprite2D

@export var speed = 1.5 
@export var flying_speed = 2.0
@export var idle_time = 2.0
@export var flying_time = 10.0
@export var flight_height = 15.0

enum {NORMAL, FLYING}
var state = NORMAL

enum {LEFT=-1, RIGHT=1, IDLE=0}
var direction = LEFT 

@onready var LeftWall = $LeftWallCast
@onready var RightWall = $RightWallCast
@onready var LeftGround = $LeftGroundCast
@onready var RightGround = $RightGroundCast
@onready var IdleTimer = $IdleTimer
@onready var FlightTimer = $FlightTimer

var base_height

signal enemy_kill

func _ready() -> void:
	IdleTimer.wait_time = idle_time
	FlightTimer.wait_time = flying_time
	base_height = global_position.y
	connect("enemy_kill", _on_enemy_kill_signal)

func _physics_process(delta: float) -> void:
	if state==NORMAL:
		position.y = move_toward(position.y, base_height, 2.0)
		if direction==LEFT and (LeftWall.is_colliding() or not LeftGround.is_colliding()):
			direction = IDLE 
			play("idle")
			IdleTimer.start()
		elif direction==RIGHT and (RightWall.is_colliding() or not RightGround.is_colliding()):
			direction = IDLE 
			play("idle")
			IdleTimer.start()
		position.x += direction * speed 
	elif state==FLYING:
		position.y = move_toward(position.y, base_height-flight_height, delta*2.0)
		if direction==LEFT and (LeftWall.is_colliding() or not LeftGround.is_colliding()):
			flip_h = true
			direction = RIGHT
		elif direction==RIGHT and (RightWall.is_colliding() or not RightGround.is_colliding()):
			flip_h = false
			direction = LEFT
		position.x += direction * speed 

func _on_idle_timer_timeout() -> void:
	if flip_h:
		direction = LEFT 
		flip_h = false 
	else:
		direction = RIGHT 
		flip_h = true 
	if state==NORMAL:
		play("run")

func _on_flight_timer_timeout() -> void:
	if state==NORMAL:
		state = FLYING
		play("flying")
	else:
		state = NORMAL
		play("run")

func _on_enemy_kill_signal():
	set_physics_process(false)
	$Hitbox/CollisionShape2D.set.call_deferred("disabled", true)
	play("hit")

func _on_animation_finished() -> void:
	if animation=="hit":
		var tween = get_tree().create_tween()
		tween.tween_property($".", "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		$StaticBody2D.queue_free.call_deferred()
		queue_free.call_deferred()
