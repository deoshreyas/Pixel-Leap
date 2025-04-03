extends Area2D

var active = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not active:
		$AnimatedSprite2D.play("unfurl")
		active = true 
		body.last_checkpoint = global_position

func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.play("checked")
