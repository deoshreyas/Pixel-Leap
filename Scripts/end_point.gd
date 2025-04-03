extends Area2D

var reached = false 
var enough_collectibles = false 

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if enough_collectibles:
			$CrossSprite.visible = false
			$AnimatedSprite2D.play("reached")
			reached = true 
			$Confetti.emit_all()
			body.set_physics_process(false)
			body.play_idle_animation()
			Globals.emit_signal("level_finished")
		else:
			$CrossSprite.visible = true 
			$CrossTimer.start()

func _on_cross_timer_timeout() -> void:
	$CrossSprite.visible = false 
