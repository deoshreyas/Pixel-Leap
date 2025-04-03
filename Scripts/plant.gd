extends AnimatedSprite2D

@export var bullet_cooldown = 1.0
@export_enum("LEFT", "RIGHT", "TOP", "DOWN") var direction = "RIGHT"
@export var bullet_speed = 5.0

var bullet = preload("res://Scenes/plant_bullet.tscn")

var player_in_view = false 
var attacking = false 
var hit = false 
var static_body_queue_freed = false 

signal enemy_kill

func _ready():
	$AttackTimer.wait_time = bullet_cooldown
	connect("enemy_kill", _on_enemy_kill_signal)

func _physics_process(_delta: float) -> void:
	if player_in_view and not attacking:
		$AttackTimer.start()
		attacking = true 
	elif not attacking:
		play("idle")

func _on_attack_timer_timeout() -> void:
	play("attack")
	await get_tree().create_timer(0.2).timeout
	var new_bullet = bullet.instantiate()
	new_bullet.speed = bullet_speed
	match direction:
		"LEFT": new_bullet.direction = new_bullet.LEFT 
		"RIGHT": new_bullet.direction = new_bullet.RIGHT 
		"TOP": new_bullet.direction = new_bullet.TOP 
		"DOWN": new_bullet.direction = new_bullet.DOWN 
	add_child(new_bullet)
	attacking = false 

func _on_player_collision_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_view = true 

func _on_player_collision_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_view = false 

func _on_animation_finished() -> void:
	if animation=="hit":
		if not static_body_queue_freed:
			$StaticBody2D.queue_free.call_deferred()
			static_body_queue_freed = true 
		var tween = get_tree().create_tween()
		tween.tween_property($".", "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		queue_free.call_deferred()

func _on_enemy_kill_signal():
	set_physics_process(false)
	$AttackTimer.stop()
	play("hit")
	hit = true 
