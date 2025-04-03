extends AnimatedSprite2D

@export var speed = 1.5 
@export var idle_time = 2.0

enum {LEFT, RIGHT, IDLE}
var state = LEFT 

signal enemy_kill

func _ready() -> void:
	connect("enemy_kill", _on_enemy_kill_signal)
	$IdleTimer.wait_time = idle_time

func _physics_process(_delta: float) -> void:
	if state==LEFT and ($LeftWallCast.is_colliding() or not $LeftGroundCast.is_colliding()):
		if $IdleTimer.is_stopped():
			state = IDLE 
			$IdleTimer.start()
	elif state==RIGHT and ($RightWallCast.is_colliding() or not $RightGroundCast.is_colliding()):
		if $IdleTimer.is_stopped():
			state = IDLE 
			$IdleTimer.start()
	match_state()

func match_state():
	match state:
		LEFT: position.x -= speed 
		RIGHT: position.x += speed 
		IDLE:
			if animation!="idle":
				play("idle")

func _on_idle_timer_timeout() -> void:
	if flip_h:
		state = LEFT 
		flip_h = false
	else:
		state = RIGHT 
		flip_h = true 
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
		$StaticBody2D.queue_free()
		queue_free.call_deferred()
