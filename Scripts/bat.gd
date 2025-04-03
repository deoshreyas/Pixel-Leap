extends Node2D

@export var flying_time = 10.0
@export var resting_time = 5.0
@export var speed = 0.2
@export var starting_point : Vector2

enum {FLYING, REST, IN, OUT}
var state = REST

var resting_pos 

@onready var AnimPlayer =  $AnimationPlayer
@onready var Path = $Path2D
@onready var PathFollow = $Path2D/PathFollow2D
@onready var FlyingTimer = $FlyingTimer
@onready var RestingTimer = $RestingTimer
@onready var AnimSprite = $AnimatedSprite2D
@onready var RemoteTransform = $Path2D/PathFollow2D/RemoteTransform2D
@onready var Hitbox = $AnimatedSprite2D/Hitbox/CollisionShape2D
@onready var Hurtbox = $AnimatedSprite2D/Hurtbox/CollisionShape2D
@onready var StaticBody = $AnimatedSprite2D/StaticBody2D/CollisionShape2D
@onready var SpriteLight = $BatLight
@onready var RemoteTransformLight = $Path2D/PathFollow2D/RemoteTransform2D/BatLight2

func _ready():
	resting_pos = AnimSprite.global_position
	FlyingTimer.wait_time = flying_time
	RestingTimer.wait_time = resting_time
	
func _physics_process(_delta: float) -> void:
	if state==IN:
		AnimSprite.global_position = AnimSprite.global_position.lerp(resting_pos, speed)
		if AnimSprite.global_position.distance_to(resting_pos) < 1.0:
			SpriteLight.enabled = true 
			RemoteTransformLight.enabled = false 
			state = REST 
			AnimSprite.play("in")
	elif state==OUT:
		AnimSprite.position = AnimSprite.position.lerp(starting_point, speed)
		if AnimSprite.position.distance_to(starting_point) < 1.0:
			SpriteLight.enabled = false 
			RemoteTransformLight.enabled = true 
			state = FLYING
			PathFollow.progress = 0
			RemoteTransform.remote_path = AnimSprite.get_path()
			AnimPlayer.play("PathFollow")
			AnimSprite.play("flying")

func _on_resting_timer_timeout() -> void:
	state = OUT
	AnimSprite.play("out")
	Hitbox.disabled = false
	Hurtbox.disabled = false 
	StaticBody.disabled = false
	FlyingTimer.start()
	
func _on_flying_timer_timeout() -> void:
	RemoteTransform.remote_path = ""
	state = IN
	AnimPlayer.stop()
	Hitbox.disabled = true
	Hurtbox.disabled = true 
	StaticBody.disabled = true
	RestingTimer.start()

func _on_animated_sprite_2d_animation_finished() -> void:
	if AnimSprite.animation=="out":
		FlyingTimer.start()
	elif AnimSprite.animation=="in":
		AnimSprite.play("idle")
		RestingTimer.start()
	elif AnimSprite.animation=="hit":
		var tween = get_tree().create_tween()
		tween.tween_property($".", "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		$AnimatedSprite2D/StaticBody2D.queue_free.call_deferred()
		queue_free.call_deferred()
