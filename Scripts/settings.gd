extends Control

var main_menu = load("res://Scenes/main_menu.tscn")
var muted = false 

func _on_back_button_pressed() -> void:
	SceneTransition.load_scene(main_menu)

func _on_reset_button_pressed() -> void:
	SaveLoad._reset()

func _on_volume_button_pressed() -> void:
	if muted:
		MusicPlayer.unmute()
		$HBoxContainer/VolumeButton.modulate = Color(1, 1, 1)
		muted = false
	else:
		MusicPlayer.mute()
		$HBoxContainer/VolumeButton.modulate = Color(0.5, 0.5, 0.5)
		muted = true
