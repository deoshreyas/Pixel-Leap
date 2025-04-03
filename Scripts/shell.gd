extends AnimatedSprite2D

var speed = 3.0

enum {LEFT=-1, RIGHT=1, WALL=0}
var direction = LEFT 

signal enemy_kill

func _ready():
	connect("enemy_kill", _on_enemy_kill_signal)
	if direction==LEFT:
		$LeftCast.enabled = true 
		$RightCast.enabled = false 
		$Hitbox/CollisionShape2D.position.x = 2
		$Hurtbox/CollisionShape2D.position.x = 3
		$StaticBody2D/CollisionShape2D.position.x = 2
	elif direction==RIGHT:
		$LeftCast.enabled = false 
		$RightCast.enabled = true 
		$Hitbox/CollisionShape2D.position.x = -2
		$Hurtbox/CollisionShape2D.position.x = -3
		$StaticBody2D/CollisionShape2D.position.x = -2

func _physics_process(_delta: float) -> void:
	if not $GroundCast.is_colliding():
		position.y += 1
	if $LeftCast.is_colliding():
		if animation!="wall_hit":
			direction = WALL 
			play("wall_hit")
	elif $RightCast.is_colliding():
		if animation!="wall_hit":
			direction = WALL 
			play("wall_hit")
	position.x += direction * speed

func _on_animation_finished() -> void:
	if animation=="wall_hit":
		if flip_h:
			direction = LEFT 
			flip_h = false 
			$RightCast.enabled = false 
			$LeftCast.enabled = true 
			$Hitbox/CollisionShape2D.position.x = 2
			$Hurtbox/CollisionShape2D.position.x = 3
			$StaticBody2D/CollisionShape2D.position.x = 2
		else:
			direction = RIGHT 
			flip_h = true
			$RightCast.enabled = true
			$LeftCast.enabled = false 
			$Hitbox/CollisionShape2D.position.x = -2
			$Hurtbox/CollisionShape2D.position.x = -3
			$StaticBody2D/CollisionShape2D.position.x = -2
		play("idle")
	elif animation=="hit":
		var tween = get_tree().create_tween()
		tween.tween_property($".", "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		$StaticBody2D/CollisionShape2D.disabled = true
		queue_free.call_deferred()

func _on_enemy_kill_signal():
	$Hitbox/CollisionShape2D.set.call_deferred("disabled", false)
	set_physics_process(false)
	play("hit")

func _on_immunity_timer_timeout() -> void:
	$Hitbox/CollisionShape2D.disabled = false 
	$Hurtbox/CollisionShape2D.disabled = false 
