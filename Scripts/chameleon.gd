extends AnimatedSprite2D

@export var speed = 1.0
@export var idle_time = 2.0

enum {LEFT=-1, RIGHT=1, IDLE=0}
var direction = LEFT 

@onready var LeftWall = $LeftWallCast
@onready var RightWall = $RightWallCast
@onready var LeftGround = $LeftGroundCast
@onready var RightGround = $RightGroundCast
@onready var IdleTimer = $IdleTimer
@onready var PlayerLeft = $PlayerDetectionLeft
@onready var PlayerRight = $PlayerDetectionRight
@onready var HitboxLeft = $HitboxLeft/CollisionShape2D
@onready var HitboxRight = $HitboxRight/CollisionShape2D
@onready var StaticLeft = $LeftBody/CollisionShape2D
@onready var StaticRight = $RightBody/CollisionShape2D
@onready var LeftHurt = $Hurtbox/CollisionShape2D
@onready var RightHurt = $Hurtbox/CollisionShape2D2

const pos_change = Vector2(-37.333, 0)

signal enemy_kill

var attacking = false 

func _ready() -> void:
	connect("enemy_kill", _on_enemy_kill_signal)
	IdleTimer.wait_time = idle_time

func _physics_process(_delta: float) -> void:
	attacking = PlayerLeft.is_colliding() or PlayerRight.is_colliding()
	if attacking and not direction==IDLE:
		attack()
	else:
		HitboxLeft.set.call_deferred("disabled", true)
		HitboxRight.set.call_deferred("disabled", true)
		if direction!=IDLE and animation!="run":
			play("run")
		if direction==LEFT and (LeftWall.is_colliding() or not LeftGround.is_colliding()):
			direction = IDLE 
			play("idle")
			IdleTimer.start()
		elif direction==RIGHT and (RightWall.is_colliding() or not RightGround.is_colliding()):
			direction = IDLE 
			play("idle")
			IdleTimer.start()
		position.x += direction * speed 

func attack():
	if animation!="attack":
		play("attack")
	
func _on_idle_timer_timeout() -> void:
	if flip_h:
		position += pos_change
		direction = LEFT 
		flip_h = false 
		PlayerLeft.enabled = true 
		PlayerRight.enabled = false
		StaticLeft.disabled = false 
		StaticRight.disabled = true 
		LeftHurt.disabled = false 
		RightHurt.disabled = true
	else:
		position -= pos_change
		direction = RIGHT 
		flip_h = true 
		PlayerLeft.enabled = false 
		PlayerRight.enabled = true
		StaticLeft.disabled = true 
		StaticRight.disabled = false
		LeftHurt.disabled = true 
		RightHurt.disabled = false
	play("run")

func _on_enemy_kill_signal():
	set_physics_process(false)
	play("hit")

func _on_animation_finished() -> void:
	if animation=="hit":
		var tween = get_tree().create_tween()
		tween.tween_property($".", "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		StaticLeft.queue_free.call_deferred()
		StaticRight.queue_free.call_deferred()
		queue_free.call_deferred()

func _on_frame_changed() -> void:
	if animation=="attack":
		if frame>13 and frame<18:
			if direction==LEFT:
				HitboxLeft.set.call_deferred("disabled", false)
				HitboxRight.set.call_deferred("disabled", true)
			else:
				HitboxLeft.set.call_deferred("disabled", true)
				HitboxRight.set.call_deferred("disabled", false)
