extends Control

var main_menu_scene = load("res://Scenes/main_menu.tscn")

func set_time(level, time):
	$PanelContainer/HBoxContainer/VBoxContainer/LevelTime.text = str(time)
	SaveLoad._load()
	SaveLoad.save_level_time(level, time)
	var new_level
	if int(level)<9:
		new_level = "0"+str(int(level)+1)
	elif int(level)<50:
		new_level = str(int(level)+1)
	if new_level not in SaveLoad.SaveFileData.levels_unlocked:
		SaveLoad.unlock_new_level(new_level)
	SaveLoad._save()

func _on_back_button_pressed() -> void:
	SceneTransition.load_scene(main_menu_scene)

func _on_restart_button_pressed() -> void:
	SceneTransition.reload_scene()

func _on_next_level_button_pressed() -> void:
	Globals.emit_signal("next_level")
