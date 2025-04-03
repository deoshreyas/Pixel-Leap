extends Area2D

@export var force = 350.0

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		$AnimatedSprite2D.play("jump")
		body.velocity.y = -force

func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.play("idle")
