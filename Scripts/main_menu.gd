extends Control

var level_selection_scene = load("res://Scenes/level_select.tscn")
var level_times = load("res://Scenes/level_times.tscn")
var settings = load("res://Scenes/settings.tscn")

func _on_play_pressed() -> void:
	SceneTransition.load_scene(level_selection_scene)

func _on_back_pressed() -> void:
	SceneTransition.load_scene(level_times)

func _on_settings_pressed() -> void:
	SceneTransition.load_scene(settings)
