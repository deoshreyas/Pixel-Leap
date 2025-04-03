extends Node2D

var main_menu_scene = load("res://Scenes/main_menu.tscn")

func _on_back_button_pressed() -> void:
	SceneTransition.load_scene(main_menu_scene)
