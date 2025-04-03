extends PathFollow2D

@export var attack_cooldown = 1.0
@export var sting_speed = 4.0
@export var sting_cooldown = 0.8

@onready var AnimSprite = $AnimatedSprite2D
@onready var AttackTimer = $"../AttackTimer"
@onready var StingTimer = $"../StingTimer"
@onready var AnimPlayer = $"../AnimationPlayer"

var stinger = preload("res://Scenes/bee_sting.tscn")

signal enemy_kill

var killed = false

func _ready():
	connect("enemy_kill", _on_enemy_kill_signal)
	AttackTimer.wait_time = attack_cooldown
	StingTimer.wait_time = sting_cooldown

func _on_attack_timer_timeout() -> void:
	if not killed:
		AnimPlayer.pause()
		AnimSprite.play("attack")
		attack()

func attack():
	var stinger_instance = stinger.instantiate()
	stinger_instance.global_position = AnimSprite.global_position
	stinger_instance.z_index = 0
	stinger_instance.speed = sting_speed
	get_tree().root.add_child(stinger_instance)
	StingTimer.start()

func _on_sting_timer_timeout() -> void:
	if not killed:
		AnimSprite.play("idle")
		AnimPlayer.play("PathFollow")

func _on_enemy_kill_signal():
	killed = true 
	AnimPlayer.pause()
	AnimSprite.play("hit")

func _on_animated_sprite_2d_animation_finished() -> void:
	if AnimSprite.animation=="hit":
		var tween = get_tree().create_tween()
		tween.tween_property($".", "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		queue_free.call_deferred()
