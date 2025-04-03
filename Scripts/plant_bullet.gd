extends Node2D

enum {LEFT, RIGHT, TOP, DOWN}

var direction = RIGHT
var speed = 5.0
	
func _physics_process(_delta: float) -> void:
	match direction:
		LEFT: global_position.x -= speed
		RIGHT: global_position.x += speed 
		TOP: global_position.y -= speed
		DOWN: global_position.y += speed
		
func _on_terrain_area_2d_body_entered(_body: Node2D) -> void:
	set_physics_process(false)
	queue_free.call_deferred()
