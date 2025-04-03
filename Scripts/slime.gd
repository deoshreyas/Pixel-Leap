extends AnimatedSprite2D

@export var speed = 2.0

var dir = -1

signal enemy_kill

func _ready():
	connect("enemy_kill", _on_enemy_kill_signal)

func _physics_process(_delta: float) -> void:
	if $LeftWallRayCast.is_colliding():
		flip_h = true
		dir = 1 
	elif $RightWallRayCast.is_colliding():
		flip_h = false
		dir = -1 
	position.x += speed * dir 

func _on_enemy_kill_signal():
	set_physics_process(false)
	$Hitbox/CollisionShape2D.set.call_deferred("disabled", true)
	play("hit")

func _on_animation_finished() -> void:
	if animation=="hit":
		var tween = get_tree().create_tween()
		tween.tween_property($".", "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		$StaticBody2D/CollisionShape2D.disabled = true
		queue_free.call_deferred()
