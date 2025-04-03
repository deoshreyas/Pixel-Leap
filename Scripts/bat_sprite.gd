extends AnimatedSprite2D

signal enemy_kill 

func _ready():
	connect("enemy_kill", _on_enemy_kill_signal)

func _on_enemy_kill_signal():
	$"../Path2D/PathFollow2D/RemoteTransform2D".remote_path = ""
	$"../AnimationPlayer".stop()
	$Hitbox/CollisionShape2D.set.call_deferred("disabled", true)
	$"../FlyingTimer".paused = true
	play("hit")
