extends CharacterBody2D
class_name Player

const GRAVITY = 8
const SPEED = 50.0
const JUMP_VELOCITY = -175
const HORIZONTAL_ACCELERATION = 20
const FRICTION = 20 
const ADDITIONAL_FAST_FELL_GRAVITY = 3
const VARIABLE_JUMP_VELOCITY = -90
const DASH_SPEED = 3
const DASH_PARTICLES_SPEED = 2000
const WALL_JUMP_PUSH_BACK = 100 
const WALL_SLIDE_GRAVITY = 40 

var double_jump = 1
var is_dashing = false 
var double_jumping = false
var double_jump_animation_playing = false 

@onready var AnimatedSprite = $AnimatedSprite2D
@onready var DashTimer = $DashTimer
@onready var DashEffectTimer = $DashEffectTimer
@onready var IceCast = $IceCast
@onready var SandCast = $SandCast

var last_checkpoint 

func _ready():
	DashTimer.connect("timeout", stop_dash)

func _physics_process(_delta):
	apply_gravity()
	
	apply_wall_sliding()
	
	var input = Vector2.ZERO 
	input.x = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("dash") and not is_on_wall():
		if !is_dashing and input.x:
			start_dash()
	
	if input.x==0:
		apply_friction()
		if not double_jump_animation_playing:
			AnimatedSprite.play("idle")
	else:
		apply_acceleration(input.x)
		if not double_jump_animation_playing:
			if not IceCast.is_colliding():
				AnimatedSprite.play("run")
			else:
				AnimatedSprite.play("idle")
				AnimatedSprite.frame = 0
		flip_sprite(input.x)
		
	if is_on_floor():
		double_jump = 1
		double_jumping = false 
		double_jump_animation_playing = false 
		if Input.is_action_just_pressed("up"):
			velocity.y = JUMP_VELOCITY
	elif is_on_wall():
		if AnimatedSprite.animation!="wall_jump":
			AnimatedSprite.play("wall_jump")
		if Input.is_action_just_pressed("up"):
			if Input.is_action_pressed("left"):
				AnimatedSprite.flip_h = true 
				velocity.y = JUMP_VELOCITY
				velocity.x = WALL_JUMP_PUSH_BACK
			elif Input.is_action_pressed("right"):
				AnimatedSprite.flip_h = false 
				velocity.y = JUMP_VELOCITY
				velocity.x = -WALL_JUMP_PUSH_BACK
	elif not is_on_floor():
		if double_jumping and not double_jump_animation_playing:
			AnimatedSprite.play("double_jump")
			double_jump_animation_playing = true 
		elif not double_jump_animation_playing:
			AnimatedSprite.play("jump")
		if Input.is_action_just_released("up") and velocity.y<VARIABLE_JUMP_VELOCITY:
			velocity.y = VARIABLE_JUMP_VELOCITY
		
		if Input.is_action_just_pressed("up") and double_jump>0:
			velocity.y = JUMP_VELOCITY
			double_jump -= 1
			double_jumping = true 
			
		if velocity.y > 0:
			velocity.y += ADDITIONAL_FAST_FELL_GRAVITY
			
	move_and_slide()

func apply_gravity():
	velocity.y += GRAVITY

func apply_wall_sliding():
	var is_wall_sliding = false
	if is_on_wall() and not is_on_floor():
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			is_wall_sliding = true 
		else:
			is_wall_sliding = false 
	else:
		is_wall_sliding = false 
	if is_wall_sliding:
		velocity.y = min(velocity.y, WALL_SLIDE_GRAVITY)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	
func apply_acceleration(x_input):
	if is_dashing:
		if IceCast.is_colliding():
			velocity.x = move_toward(velocity.x, SPEED*x_input*DASH_SPEED*1.25, HORIZONTAL_ACCELERATION)
		elif SandCast.is_colliding():
			velocity.x = move_toward(velocity.x, SPEED*x_input*DASH_SPEED*0.5, HORIZONTAL_ACCELERATION)
		else:
			velocity.x = move_toward(velocity.x, SPEED*x_input*DASH_SPEED, HORIZONTAL_ACCELERATION)
	else:	
		if IceCast.is_colliding():
			velocity.x = move_toward(velocity.x, SPEED*x_input*2, HORIZONTAL_ACCELERATION)
		elif SandCast.is_colliding():
			velocity.x = move_toward(velocity.x, SPEED*x_input*0.5, HORIZONTAL_ACCELERATION)
		else:
			velocity.x = move_toward(velocity.x, SPEED*x_input, HORIZONTAL_ACCELERATION)

func flip_sprite(x_input):
	if x_input > 0:
		AnimatedSprite.flip_h = false 
	else:
		AnimatedSprite.flip_h = true

func start_dash():
	is_dashing = true
	DashTimer.start()
	DashEffectTimer.start()
	
func stop_dash():
	is_dashing = false 
	DashEffectTimer.stop()

func create_dash_effect():
	var playerCopyNode = AnimatedSprite.duplicate()
	playerCopyNode.add_to_group("DashEffect")
	get_parent().add_child(playerCopyNode)
	if double_jump_animation_playing:
		playerCopyNode.animation = "double_jump"
		playerCopyNode.frame = AnimatedSprite.frame
		playerCopyNode.pause()
	else:
		playerCopyNode.animation = "jump"
	playerCopyNode.set_indexed("z_index", 1)
	playerCopyNode.global_position = global_position
	playerCopyNode.modulate = Color(0, 0, 0, 1)
	var animationTime = DashTimer.wait_time / 3 
	await get_tree().create_timer(animationTime).timeout
	playerCopyNode.modulate.a = 0.4 
	await get_tree().create_timer(animationTime).timeout
	playerCopyNode.modulate.a = 0.2
	await get_tree().create_timer(animationTime).timeout
	playerCopyNode.queue_free()

func _on_dash_effect_timer_timeout() -> void:
	create_dash_effect()

func respawn():
	modulate.a = 0
	set_physics_process(false)
	await get_tree().create_timer(0.5).timeout
	global_position = last_checkpoint
	await get_tree().create_timer(0.5).timeout
	AnimatedSprite.play("idle")
	modulate.a = 1
	velocity = Vector2.ZERO
	set_physics_process(true)

func play_idle_animation():
	$AnimatedSprite2D.play("idle")
