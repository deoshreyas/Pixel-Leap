extends AnimatedSprite2D

@export var speed = 2.0

enum {LEFT=-1, RIGHT=1}
var state = LEFT 

signal enemy_kill

func _ready():
	connect("enemy_kill", _on_enemy_kill_signal)

func _physics_process(_delta: float) -> void:
	if state==LEFT and $LeftCast.is_colliding():
		flip_h = true 
		state = RIGHT 
		$Hurtbox/CollisionShape2D.position.x = -3.0
		$StaticBody2D/CollisionShape2D.position.x = -4.0
	elif state==RIGHT and $RightCast.is_colliding():
		flip_h = false 
		state = LEFT 
		$Hurtbox/CollisionShape2D.position.x = 3.0
		$StaticBody2D/CollisionShape2D.position.x = 4.0
	position.x += state * speed

func _on_enemy_kill_signal():
	set_physics_process(false)
	$Hitbox/CollisionShape2D.set.call_deferred("disabled", true)
	play("hit")

func _on_animation_finished() -> void:
	if animation=="hit":
		var tween = get_tree().create_tween()
		tween.tween_property($".", "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		$StaticBody2D/CollisionShape2D.queue_free.call_deferred()
		queue_free.call_deferred()
