extends StaticBody2D

var falling = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and !body.is_in_group("DashEffect"):
		$AnimatedSprite2D.play("deactivated")
		sprite_flash()
		await get_tree().create_timer(0.4).timeout
		falling = true 
		
func _physics_process(_delta: float) -> void:
	if falling:
		position.y += 4
		rotate(0.05)
		if position.y > 1500:
			queue_free()

func sprite_flash() -> void:
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate:v", 1, 0.25).from(15)
