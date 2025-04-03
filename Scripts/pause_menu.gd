extends Control

var pausable = true

var main_menu_scene = load("res://Scenes/main_menu.tscn")

func pause():
	visible = true 
	get_tree().paused = true 

func resume():
	visible = false 
	get_tree().paused = false 

func _on_back_button_pressed() -> void:
	SceneTransition.load_scene(main_menu_scene)

func _on_play_button_pressed() -> void:
	resume()

func _on_restart_button_pressed() -> void:
	resume()
	SceneTransition.reload_scene()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and pausable:
		if not get_tree().paused:
			pause() 
		elif get_tree().paused:
			resume()
