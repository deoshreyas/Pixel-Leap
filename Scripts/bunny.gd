extends AnimatedSprite2D

@export var speed = 2.0
@export var idle_time = 2.0 

enum {NORMAL, ATTACKING}
var state = NORMAL 

enum {LEFT=-1, RIGHT=1, IDLE=0}
var direction = LEFT 

@onready var LeftWall = $LeftWallCast
@onready var RightWall = $RightWallCast
@onready var LeftPlayer = $LeftPlayer
@onready var RightPlayer = $RightPlayer
@onready var IdleTimer = $IdleTimer
@onready var JumpTimer = $JumpTimer
@onready var StaticBody = $StaticBody2D/CollisionShape2D
@onready var Hitbox = $Hitbox/CollisionShape2D

@onready var ground_y = global_position.y

var jump = false 
	
var vx = 1
var vy = 1 
var gravity = 0.05

signal enemy_kill 

func _ready() -> void:
	connect("enemy_kill", _on_enemy_kill_signal)

func _physics_process(_delta: float) -> void:
	if LeftPlayer.is_colliding() and not LeftWall.is_colliding():
		flip_h = false 
		state = ATTACKING
		direction = LEFT 
		if animation!="run":
			play("run")
	elif RightPlayer.is_colliding() and not RightWall.is_colliding():
		flip_h = true 
		state = ATTACKING
		direction = RIGHT 
		if animation!="run":
			play("run")
	else:
		state = NORMAL
		play("idle")
		if JumpTimer.is_stopped():
			JumpTimer.start()
	if not jump or animation=="fall":
		vy = 1 
	if state==ATTACKING:
		if direction==LEFT and LeftWall.is_colliding():
			direction = IDLE
			IdleTimer.start()
			play("idle")
		elif direction==RIGHT and RightWall.is_colliding():
			direction = IDLE
			IdleTimer.start()
			play("idle")
		position.x += speed * direction 
	elif state==NORMAL:
		if direction==LEFT and LeftWall.is_colliding():
			direction = RIGHT 
			flip_h = true 
		elif direction==RIGHT and RightWall.is_colliding():
			direction = LEFT
			flip_h = false 
		if jump:
			play("jump")
			if direction==LEFT:
				position.x -= vx 
			else:
				position.x += vx 
			position.y -= vy 
			vy -= gravity 
			if vy<=0:
				play("fall")
			if global_position.y==ground_y:
				jump = false 
		else:
			if animation=="fall":
				vy = 1 
				JumpTimer.start()
				play("idle")

func _on_jump_timer_timeout() -> void:
	jump = true 

func _on_enemy_kill_signal():
	Hitbox.set.call_deferred("disabled", true)
	set_physics_process(false)
	play("hit")

func _on_animation_finished() -> void:
	if animation=="hit":
		var tween = get_tree().create_tween()
		tween.tween_property($".", "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		StaticBody.queue_free.call_deferred()
		queue_free.call_deferred()

func _on_idle_timer_timeout() -> void:
	if flip_h:
		direction = LEFT 
		flip_h = false
	else:
		direction = RIGHT 
		flip_h = true
	play("run")
