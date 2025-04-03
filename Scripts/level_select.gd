extends Control

var main_menu = load("res://Scenes/main_menu.tscn")

var current = 1
var total_containers = 3

func match_current():
	match current:
		1: 
			%Container1.visible = true 
			%Container2.visible = false 
			%Container3.visible = false 
		2:
			%Container1.visible = false 
			%Container2.visible = true 
			%Container3.visible = false 
		3:
			%Container1.visible = false 
			%Container2.visible = false 
			%Container3.visible = true 

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
