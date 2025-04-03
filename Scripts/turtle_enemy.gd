extends AnimatedSprite2D

@export var speed = 2.0
@export var cooldown_timer = 5.0 
@export var unspiked_time = 1.5

enum {LEFT, RIGHT, UNSPIKED}
var state = RIGHT
var last_state = RIGHT 

signal enemy_kill

func _ready():
	$CooldownTimer.wait_time = cooldown_timer
	$UnspikedTimer.wait_time = unspiked_time
	connect("enemy_kill", _on_enemy_kill_signal)

func _physics_process(_delta: float) -> void:
	if $LeftRayCast.is_colliding() and state!=UNSPIKED: 
		state = RIGHT 
		flip_h = true  
	elif $RightRayCast.is_colliding() and state!=UNSPIKED: 
		state = LEFT 
		flip_h = false 
	match_state()
	
func match_state():
	if state==LEFT:
		position.x -= speed 
	elif state==RIGHT:
		position.x += speed 

func _on_cooldown_timer_timeout() -> void:
	last_state = state 
	state = UNSPIKED
	play("spikes_in")
	$Hitbox/HitboxCollision.disabled = true 
	$UnspikedTimer.start()
	$UnspikedStaticBody/UnspikedStaticBodyCollision.disabled = false 
	$Hurtbox/CollisionShape2D.disabled = false 

func _on_unspiked_timer_timeout() -> void:
	state = last_state
	play("spikes_out")
	$Hitbox/HitboxCollision.disabled = false  
	$CooldownTimer.start()
	$UnspikedStaticBody/UnspikedStaticBodyCollision.disabled = true 
	$Hurtbox/CollisionShape2D.disabled = true 

func _on_enemy_kill_signal():
	set_physics_process(false)
	play("hit")

func _on_animation_finished() -> void:
	if animation=="hit":
		var tween = get_tree().create_tween()
		tween.tween_property($".", "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		queue_free.call_deferred()
