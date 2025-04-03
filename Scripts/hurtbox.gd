extends Area2D

var killed = false 

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if not killed:
			Globals.emit_signal("update_collectible_count", "enemy")
			killed = true 
		get_parent().emit_signal("enemy_kill")
