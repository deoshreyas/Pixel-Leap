extends AnimatedSprite2D

var running = false
var direction = 1 
var attacking = false 

@export var speed = 3.0
@export_enum("LEFT", "RIGHT") var enemy_direction = "RIGHT"

var knockbacking = false 

var pause_movement = false 

signal enemy_kill

func _ready():
	connect("enemy_kill", _on_enemy_kill_signal)
	if enemy_direction=="LEFT":
		direction = -1 
		$WallRayCast2D.set("rotation", deg_to_rad(180))
		$PlayerDetectRayCast2D.set("rotation", deg_to_rad(180))
		$Hitbox/CollisionShape2D.position.x = -18 
		$StaticBody2D/CollisionShape2D.position.x = 6
		flip_h = false 
	else:
		direction = 1
		$PlayerDetectRayCast2D.set("rotation", deg_to_rad(0))
		$PlayerDetectRayCast2D.set("rotation", deg_to_rad(0))
		$Hitbox/CollisionShape2D.position.x = 18 
		$StaticBody2D/CollisionShape2D.position.x = -6
		flip_h = true 

var knockback_dist = 2 * direction

func _physics_process(_delta: float) -> void:
	if knockbacking:
		position.x = move_toward(position.x, -direction*knockback_dist, -direction*1.5)
		return 
	if attacking:
		attack()
	if $WallRayCast2D.is_colliding():
		if $WallRayCast2D.rotation_degrees==180:
			$WallRayCast2D.set("rotation", deg_to_rad(0))
			$PlayerDetectRayCast2D.set("rotation", deg_to_rad(0))
		else:	
			$WallRayCast2D.set("rotation", deg_to_rad(180))
			$PlayerDetectRayCast2D.set("rotation", deg_to_rad(180))
		play("wall_hit")
		set_physics_process(false)
	if $PlayerDetectRayCast2D.is_colliding():
		attacking = true 

func attack():
	if not running:
		play("run")
		running = true  
	if not pause_movement:
		position.x += speed * direction 

func _on_animation_finished() -> void:
	if animation=="wall_hit":
		attacking = false 
		running = false 
		direction = direction * -1
		play("idle")
		set_physics_process(true)
		$KnockbackTimer.start()
		knockbacking = true 
	elif animation=="hit":
		$Hitbox/CollisionShape2D.disabled = true
		var tween = get_tree().create_tween()
		tween.tween_property($".", "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		$Hitbox/CollisionShape2D.disabled = true 
		queue_free.call_deferred()

func _on_knockback_timer_timeout() -> void:
	flip_h = false if flip_h else true 
	flip_collision_shapes()
	knockbacking = false 

func _on_enemy_kill_signal():
	set_physics_process(false)
	$Hitbox/CollisionShape2D.set.call_deferred("disabled", true)
	play("hit")

func flip_collision_shapes():
	if direction==-1:
		$Hitbox/CollisionShape2D.position.x = -18 
		$StaticBody2D/CollisionShape2D.position.x = 6
	else:
		$Hitbox/CollisionShape2D.position.x = 18 
		$StaticBody2D/CollisionShape2D.position.x = -6

func _on_hurtbox_body_entered(_body: Node2D) -> void:
	pause_movement = true 
