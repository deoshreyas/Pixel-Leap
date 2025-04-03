extends Node

const SAVE_LOCATION = "user://save.res"

var SaveFileData : SaveDataResource = SaveDataResource.new() 

func _save():
	ResourceSaver.save(SaveFileData, SAVE_LOCATION)

func _load():
	if FileAccess.file_exists(SAVE_LOCATION):
		SaveFileData = ResourceLoader.load(SAVE_LOCATION).duplicate(true)

func save_level_time(level_str, time):
	var saved_time = SaveFileData.level_times[level_str]
	if saved_time==0 or time<saved_time:
		SaveFileData.level_times[level_str] = time 
		_save()

func unlock_new_level(new_level):
	var levels_unlocked = SaveFileData.levels_unlocked
	levels_unlocked.append(new_level)
	_save()
	
func _reset():
	SaveFileData = SaveDataResource.new()
	_save()
