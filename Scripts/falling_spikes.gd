extends Node2D

@export var speed = 2.0
var falling = false 

func _physics_process(_delta: float) -> void:
	if falling:
		position.y += speed 
		speed += 0.1
	if $GroundCast.is_colliding():
		falling = false 
		await get_tree().create_timer(0.5).timeout
		queue_free.call_deferred()

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body is Player:
		falling = true 
