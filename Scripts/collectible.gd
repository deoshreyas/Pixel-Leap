extends Node2D

@export_enum("apple", "cherry", "banana", "kiwi", "melon", "orange", "pineapple", "strawberry") var type = "apple"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		MusicPlayer.play_collect_sound()
		$AnimatedSprite2D.play("collect")
		Globals.emit_signal("update_collectible_count", type)

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free.call_deferred()
