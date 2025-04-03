extends AnimatedSprite2D

@export var speed = 2.0 

enum {UP=-1, DOWN=1, IDLE=0}
var direction = UP

@onready var UpperWall = $UpperWallCast
@onready var LowerWall = $LowerWallCast
@onready var Hitbox = $Hitbox/CollisionShape2D
@onready var Hurtbox = $Hurtbox/CollisionShape2D

signal enemy_kill 

func _ready() -> void:
	connect("enemy_kill", _on_enemy_kill_signal)

func _physics_process(_delta: float) -> void:
	if direction==UP and UpperWall.is_colliding():
		direction = IDLE 
		play("normal_wall_hit")
		$PointLight2D.energy = 0.75
		$PointLight2D.texture_scale = 0.75
	elif direction==DOWN and LowerWall.is_colliding():
		direction = IDLE
		play("angry_wall_hit")
		$PointLight2D.energy = 0.25
		$PointLight2D.texture_scale = 0.5
	position.y += direction * speed 

func _on_animation_finished() -> void:
	if animation=="normal_wall_hit":
		direction = DOWN
		Hitbox.disabled = false 
		Hurtbox.disabled = true
		play("angry_idle")
	elif animation=="angry_wall_hit":
		direction = UP
		Hitbox.disabled = true
		Hurtbox.disabled = false
		play("normal_idle")
	elif animation=="hit":
		var tween = get_tree().create_tween()
		tween.tween_property($".", "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		queue_free.call_deferred()

func _on_enemy_kill_signal():
	set_physics_process(false)
	play("hit")
