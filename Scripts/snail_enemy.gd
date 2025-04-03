extends AnimatedSprite2D

@export var snail_speed = 1.0 
@export var shell_speed = 3.0
@export var idle_time = 1.0

@onready var SnailLeftCast = $LeftWallCast
@onready var SnailRightCast = $RightWallCast
@onready var SnailIdleTimer = $IdleTimer
@onready var SnailHitbox = $Hitbox/CollisionShape2D
@onready var SnailStatic = $StaticBody2D/CollisionShape2D
@onready var SnailHurtbox = $Hurtbox/CollisionShape2D

enum {LEFT=-1, RIGHT=1, IDLE=0}
var state = LEFT 

signal enemy_kill

var shell = preload("res://Scenes/shell.tscn")

func _ready():
	connect("enemy_kill", _on_enemy_kill_signal)
	SnailIdleTimer.wait_time = idle_time

func _physics_process(_delta: float) -> void:
	if SnailLeftCast.is_colliding():
		if SnailIdleTimer.is_stopped():
			state = IDLE 
			play("idle")
			SnailIdleTimer.start()
	elif SnailRightCast.is_colliding():
		if SnailIdleTimer.is_stopped():
			state = IDLE
			play("idle")
			SnailIdleTimer.start() 
	position.x += state * snail_speed 

func _on_idle_timer_timeout() -> void:
	if flip_h:
		state = LEFT  
		flip_h = false 
		SnailLeftCast.enabled = true
		SnailRightCast.enabled = false 
		SnailHitbox.position.x = -14.0
		SnailStatic.position.x = 5.0 
		SnailHurtbox.position.x = 6.667
	else:
		state = RIGHT 
		flip_h = true
		SnailLeftCast.enabled = false
		SnailRightCast.enabled = true 
		SnailHitbox.position.x = 14.0
		SnailStatic.position.x = -5.0
		SnailHurtbox.position.x = -6.667
	play("walk")

func _on_enemy_kill_signal():
	SnailHitbox.set.call_deferred("disabled", true)
	set_physics_process(false)
	play("hit")

func _on_animation_finished() -> void:
	spawn_shell()
	var tween = get_tree().create_tween()
	tween.tween_property($".", "modulate:a", 0, 0.5)
	await get_tree().create_timer(0.5).timeout
	$StaticBody2D.queue_free()

func spawn_shell():
	var shell_instance = shell.instantiate()
	shell_instance.flip_h = true if flip_h else false 
	shell_instance.speed = shell_speed
	if flip_h:
		shell_instance.direction = RIGHT 
		shell_instance.position = position + Vector2(-4.0, -2.667)
	else:
		shell_instance.direction = LEFT
		shell_instance.position = position + Vector2(4.0, -2.667)
	get_tree().root.add_child(shell_instance)
	queue_free.call_deferred()
