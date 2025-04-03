extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready():
	canvas_layer.visible = false 

func load_scene(target_scene: PackedScene) -> void:
	get_tree().paused = true 
	animation_player.play("in")
	await animation_player.animation_finished
	get_tree().change_scene_to_packed(target_scene)
	animation_player.play("out")
	await animation_player.animation_finished
	get_tree().paused = false 

func reload_scene():
	get_tree().paused = true 
	animation_player.play("in")
	await animation_player.animation_finished
	get_tree().reload_current_scene()
	animation_player.play("out")
	await animation_player.animation_finished
	get_tree().paused = false 
