extends AnimatedSprite2D

@export var jump_timer = 5.0 

var vx = 0.8
var vy = 1 
var gravity = 0.01

enum {LEFT, RIGHT}
var facing = LEFT 
var jumping = false

@onready var ground_y = global_position.y

@onready var StaticBody = $StaticBody2D/CollisionPolygon2D
@onready var Hitbox = $Hitbox/CollisionShape2D
@onready var Hurtbox = $Hurtbox/CollisionShape2D

signal enemy_kill

func _ready() -> void:
	connect("enemy_kill", _on_enemy_kill_signal)

func _physics_process(_delta: float) -> void:
	if jumping:
		play("jump")
		if facing==LEFT:
			flip_h = false 
			Hurtbox.position.x = -3.667
			StaticBody.scale.x = 1.0
			global_position.x -= vx 
		else:
			flip_h = true 
			Hurtbox.position.x = 3.667
			StaticBody.scale.x = -1.0
			global_position.x += vx 
		global_position.y -= vy
		vy -= gravity
		if vy<=0:
			play("fall")
		if global_position.y==ground_y:
			facing = RIGHT if facing==LEFT else LEFT 
			jumping = false 
	else:
		if animation=="fall":
			vy = 1
			$JumpTimer.start()
			play("idle")

func _on_jump_timer_timeout() -> void:
	play("anticipate")

func _on_animation_finished() -> void:
	if animation=="anticipate":
		jumping = true
	elif animation=="hit":
		var tween = get_tree().create_tween()
		tween.tween_property($".", "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		StaticBody.queue_free.call_deferred()
		queue_free.call_deferred()

func _on_enemy_kill_signal():
	set_physics_process(false)
	Hitbox.set.call_deferred("disabled", true)
	StaticBody.set.call_deferred("disabled", false)
	play("hit")
