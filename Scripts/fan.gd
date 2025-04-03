extends AnimatedSprite2D

const UPFORCE = -150

var active = false 
var body

func _physics_process(_delta: float) -> void:
	if active:
		if $PlayerCast1.is_colliding():
			body = $PlayerCast1.get_collider()
			body.velocity.y = UPFORCE
		elif $PlayerCast2.is_colliding():
			body = $PlayerCast2.get_collider()
			body.velocity.y = UPFORCE 
		elif $PlayerCast3.is_colliding():
			body = $PlayerCast3.get_collider()
			body.velocity.y = UPFORCE

func _on_active_timer_timeout() -> void:
	if active:
		active = false 
		play("off")
		$Particles.emitting = false
	else:
		active = true 
		play("on")
		$Particles.emitting = true
