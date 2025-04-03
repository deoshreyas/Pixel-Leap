extends AnimatedSprite2D

@export var speed = 2.0

enum {LEFT, RIGHT, IDLE}
var state = IDLE

signal enemy_kill

func _ready():
	connect("enemy_kill", _on_enemy_kill_signal)

func _physics_process(_delta: float) -> void:
	match state:
		LEFT: run_left() 
		RIGHT: run_right() 
		IDLE:
			if animation!="idle": animation = "idle"

func run_left():
	if animation!="run": animation = "run"
	if not $LeftWallCast.is_colliding() and $LeftFloorCast.is_colliding():
		position.x -= speed 
	else:
		state = IDLE

func run_right():
	if animation!="run": animation = "run"
	if not $RightWallCast.is_colliding() and $RightFloorCast.is_colliding():
		position.x += speed 
	else:
		state = IDLE

func _on_left_player_detection_area_body_entered(_body: Node2D) -> void:
	flip_h = false 
	state = LEFT

func _on_right_player_detection_area_body_entered(_body: Node2D) -> void:
	flip_h = true 
	state = RIGHT

func _on_left_player_detection_area_body_exited(_body: Node2D) -> void:
	state = IDLE

func _on_right_player_detection_area_body_exited(_body: Node2D) -> void:
	state = IDLE

func _on_enemy_kill_signal():
	$Hitbox/CollisionShape2D.set.call_deferred("disabled", true)
	set_physics_process(false)
	play("hit")

func _on_animation_finished() -> void:
	if animation=="hit":
		var tween = get_tree().create_tween()
		tween.tween_property($".", "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		$StaticBody2D/CollisionShape2D.disabled = true
		queue_free.call_deferred()
