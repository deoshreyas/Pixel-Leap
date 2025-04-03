extends Control

var main_menu = load("res://Scenes/main_menu.tscn")

var level_time_scene = preload("res://Scenes/level_time_scene.tscn")

var row = {
	1: "Row1", 
	2: "Row1",
	3: "Row1",
	4: "Row1",
	5: "Row2",
	6: "Row2",
	7: "Row2",
	8: "Row2", 
	9: "Row3", 
	10: "Row3", 
	11: "Row3", 
	12: "Row3", 
	13: "Row4", 
	14: "Row4", 
	15: "Row4", 
	16: "Row4",
	17: "Row5", 
	18: "Row5", 
	19: "Row5",  
	20: "Row5"
}

func _ready():
	SaveLoad._load()
	var times = SaveLoad.SaveFileData.level_times
	for t in times:
		var level_int = int(t)
		var level_time_instance = level_time_scene.instantiate()
		level_time_instance.level = load("res://Assets/Levels/%s.png"%t)
		level_time_instance.time = times[t]
		if times[t]==0:
			level_time_instance.active = false 
		if level_int<=20:
			get_node("Slide1/%s"%row[level_int]).add_child(level_time_instance)
		elif level_int<=40:
			level_int -= 20 
			get_node("Slide2/%s"%row[level_int]).add_child(level_time_instance)
		else:
			level_int -= 40 
			get_node("Slide3/%s"%row[level_int]).add_child(level_time_instance)

var current = 1
var total_containers = 3

func match_current():
	match current:
		1: 
			$Slide1.visible = true 
			$Slide2.visible = false 
			$Slide3.visible = false 
		2:
			$Slide1.visible = false 
			$Slide2.visible = true 
			$Slide3.visible = false 
		3:
			$Slide1.visible = false 
			$Slide2.visible = false 
			$Slide3.visible = true 

func _on_previous_button_pressed() -> void:
	if current>1:
		current -= 1 
	match_current()

func _on_next_button_pressed() -> void:
	if current<total_containers:
		current += 1 
	match_current()

func _on_back_button_pressed() -> void:
	SceneTransition.load_scene(main_menu)
