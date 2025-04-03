extends AnimatedSprite2D

@export var idle_time = 2.0 
@export var anger_time = 10.0
@export var normal_speed = 1.0
@export var angry_speed = 2.0 

@onready var AngerTimer = $AngerTimer
@onready var IdleTimer = $IdleTimer
@onready var LeftWall = $LeftWallCast
@onready var LeftGround = $LeftGroundCast
@onready var RightWall = $RightWallCast
@onready var RightGround = $RightGroundCast
@onready var Hitbox = $Hitbox/CollisionShape2D

enum {NORMAL, ANGRY}
var state = NORMAL

enum {LEFT=-1, RIGHT=1, IDLE=0}
var direction = LEFT

signal enemy_kill

func _ready():
	connect("enemy_kill", _on_enemy_kill_signal)
	AngerTimer.wait_time = anger_time
	IdleTimer.wait_time = idle_time

func _physics_process(_delta: float) -> void:
	if state==NORMAL:
		normal_walk()
	elif state==ANGRY:
		angry_run()

func normal_walk():
	if direction==LEFT and (LeftWall.is_colliding() or not LeftGround.is_colliding()):
		play("normal_idle")
		direction = IDLE 
		IdleTimer.start()
	elif direction==RIGHT and (RightWall.is_colliding() or not RightGround.is_colliding()):
		play("normal_idle")
		direction = IDLE 
		IdleTimer.start()
	position.x += normal_speed * direction

func _on_idle_timer_timeout() -> void:
	if flip_h:
		direction = LEFT 
		flip_h = false 
	else:
		direction = RIGHT 
		flip_h = true 
	if state==NORMAL:
		play("normal_walk")

func _on_anger_timer_timeout() -> void:
	if state==NORMAL: 
		state = ANGRY 
		play("angry_run")
		Hitbox.disabled = false
	else:
		state = NORMAL
		play("normal_walk")
		Hitbox.disabled = true

func angry_run():
	if direction==LEFT and (LeftWall.is_colliding() or not LeftGround.is_colliding()):
		direction = RIGHT 
		flip_h = true 
	elif direction==RIGHT and (RightWall.is_colliding() or not RightGround.is_colliding()):
		direction = LEFT
		flip_h = false 
	position.x += angry_speed * direction

func _on_enemy_kill_signal():
	set_physics_process(false)
	Hitbox.set.call_deferred("disable", true)
	if state==NORMAL:
		play("normal_hit")
	else:
		play("angry_hit")

func _on_animation_finished() -> void:
	if animation=="normal_hit" or animation=="angry_hit":
		var tween = get_tree().create_tween()
		tween.tween_property($".", "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		$StaticBody2D/CollisionShape2D.queue_free.call_deferred()
		queue_free.call_deferred()
