extends Node2D

@export var total_collectibles = 0 
@export var LevelName = "01"
@export var next_level : PackedScene

@onready var timer = $LevelTimer
@onready var timer_text = $UILayer/VBoxContainer/TimerText
@onready var pause_menu = $PauseCanvasLayer/PauseMenu
@onready var level_finished_menu = $PauseCanvasLayer/LevelFinished
@onready var endpoint = $EndPoint

var time_elapsed = 0 
var level_finished = false

func _ready():
	timer.connect("timeout", update_time)
	$Player.last_checkpoint = $StartPoint.global_position
	Globals.connect("level_finished", _on_level_finished)
	Globals.connect("update_collectible_count", _update_collectible_count)
	Globals.connect("next_level", _next_level)

func update_time():
	if not level_finished:
		time_elapsed += 0.1
	else:
		timer.queue_free()

func _process(_delta):
	if not level_finished:
		# We cannot use time_elapsed directly due to a bug that sometimes 
		# makes a number like 10.1 appear as 10.000000000000001 
		timer_text.text = str(round_to_dec(time_elapsed, 1))
	else:
		timer_text.set("theme_override_colors/font_color", Color(1.0, 1.0, 0))
		level_finished_menu.set_time(LevelName, round_to_dec(time_elapsed, 1))
		level_finished_menu.visible = true 

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func _on_level_finished():
	level_finished = true
	pause_menu.pausable = false

func _on_pause_button_pressed() -> void:
	if not level_finished:
		if not get_tree().paused:
			get_tree().paused = true 
			pause_menu.visible = true 
		else:
			get_tree().paused = false 
			pause_menu.visible = false 

func _update_collectible_count(collectible):
	%CollectiblesUILayer.increment(collectible)
	if %CollectiblesUILayer.num_collectibles>=total_collectibles:
		endpoint.enough_collectibles = true 

func _next_level():
	SceneTransition.load_scene(next_level)
