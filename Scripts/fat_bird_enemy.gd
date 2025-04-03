extends AnimatedSprite2D

@export var rise_distance = 100.0
@export var flap_speed = 1.0
@export var gravity = 5.0 
@export var rest_time = 0.5 

enum {FLY, FALL}
var state = FLY 

var on_ground = false 
var reached_top = false 

var top_coord
var bottom_coord

signal enemy_kill

func _ready():
	top_coord = global_position.y - rise_distance
	bottom_coord = global_position.y
	$RestTimer.wait_time = rest_time
	connect("enemy_kill", _on_enemy_kill_signal)

func _physics_process(_delta: float) -> void:
	match state:
		FLY: fly()
		FALL: fall() 
		
func fly():
	if animation!="fly":
		play("fly")
		$Hitbox/CollisionShape2D.disabled = true
	position.y = move_toward(position.y, top_coord, flap_speed) 
	if position.y==top_coord and not reached_top:
		$RestTimer.start()
		reached_top = true  

func fall():
	if animation!="fall":
		play("fall")
		$Hitbox/CollisionShape2D.disabled = false
	position.y = move_toward(position.y, bottom_coord, gravity) 
	if position.y==bottom_coord and not on_ground:
		play("ground")
		$Hurtbox/CollisionShape2D.disabled = false
		$RestTimer.start()
		on_ground = true 

func _on_rest_timer_timeout() -> void:
	match state:
		FLY: 
			state=FALL 
			reached_top = false 
		FALL: 
			state=FLY
			on_ground = false 
			$Hurtbox/CollisionShape2D.disabled = true

func _on_enemy_kill_signal():
	set_physics_process(false)
	$Hitbox/CollisionShape2D.set.call_deferred("disabled", true)
	play("hit")

func _on_animation_finished() -> void:
	if animation=="hit":
		var tween = get_tree().create_tween()
		tween.tween_property($".", "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		$StaticBody2D.queue_free()
		queue_free.call_deferred()
