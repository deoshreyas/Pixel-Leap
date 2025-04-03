extends AnimatedSprite2D

enum {LEFT, RIGHT, IDLE}

var state = LEFT 

@export var speed = 2.0
@export var idle_time = 1 

signal enemy_kill

var attacking = false 

var bullet = preload("res://Scenes/trunk_bullet.tscn")

func _ready() -> void:
	connect("enemy_kill", _on_enemy_kill_signal)
	$IdleTimer.wait_time = idle_time

func _physics_process(_delta: float) -> void:
	if not attacking:
		if state==LEFT and ($LeftWallCast.is_colliding() or not $LeftGroundCast.is_colliding()):
			if $IdleTimer.is_stopped():
				state = IDLE 
				$IdleTimer.start()
		elif state==RIGHT and ($RightWallCast.is_colliding() or not $RightGroundCast.is_colliding()):
			if $IdleTimer.is_stopped():
				state = IDLE 
				$IdleTimer.start()
		match_state()
	else:
		if animation!="attack":
			play("attack")

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
		$PlayerDetectionArea/CollisionShape2D.position.x = -177.333
	else:
		state = RIGHT 
		flip_h = true 
		$PlayerDetectionArea/CollisionShape2D.position.x = 177.333
	play("run")

func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if body is Player and state!=IDLE:
		attacking = true 

func _on_player_detection_area_body_exited(body: Node2D) -> void:
	if body is Player:
		attacking = false
		play("run")

func _on_enemy_kill_signal():
	set_physics_process(false)
	play("hit")

func _on_animation_finished() -> void:
	if animation=="attack":
		var bullet_instance = bullet.instantiate()
		if state==LEFT:
			bullet_instance.direction = -1
		else:
			bullet_instance.direction = 1 
		bullet_instance.global_position = global_position
		bullet_instance.global_position.y += 2
		bullet_instance.z_index = 0
		get_tree().root.add_child(bullet_instance)
		if attacking:
			play("attack")
	elif animation=="hit":
		var tween = get_tree().create_tween()
		tween.tween_property($".", "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		$StaticBody2D.queue_free()
		queue_free.call_deferred()
