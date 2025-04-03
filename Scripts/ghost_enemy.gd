extends AnimatedSprite2D

@export var speed = 3.0

enum {LEFT, RIGHT, DISAPPEARED}

var state = LEFT 
var last_state = LEFT 

signal enemy_kill

func _ready():
	connect("enemy_kill", _on_enemy_kill_signal)

func _physics_process(_delta: float) -> void:
	if $LeftWallCast.is_colliding() or not $LeftGroundCast.is_colliding():
		flip_h = true 
		state = RIGHT 
	elif $RightWallCast.is_colliding() or not $RightGroundCast.is_colliding():
		flip_h = false 
		state = LEFT 
	match_state()

func match_state():
	match state:
		LEFT: position.x -= speed 
		RIGHT: position.x += speed

func _on_appear_timer_timeout() -> void:
	if state==DISAPPEARED:  
		state = last_state
		$Hitbox/CollisionShape2D.disabled = false 
		$Hurtbox/CollisionShape2D.disabled = false 
		$StaticBody2D/CollisionShape2D.disabled = false 
		play("appear")
		$SpriteLight.enabled = true 
	else:
		last_state = state 
		state = DISAPPEARED
		$Hitbox/CollisionShape2D.disabled = true 
		$Hurtbox/CollisionShape2D.disabled = true 
		$StaticBody2D/CollisionShape2D.disabled = true 
		play("disappear") 
		$SpriteLight.enabled = false 

func _on_animation_finished() -> void:
	if animation=="appear":
		play("idle")
	elif animation=="hit":
		var tween = get_tree().create_tween()
		tween.tween_property($".", "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		$StaticBody2D.queue_free()
		queue_free.call_deferred()

func _on_enemy_kill_signal():
	set_physics_process(false)
	$Hitbox/CollisionShape2D.set.call_deferred("disabled", true) 
	play("hit")
