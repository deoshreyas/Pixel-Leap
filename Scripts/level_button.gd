@tool
extends Button

@export var Name : String = "01"
@export var Level : PackedScene 
@export var Icon : CompressedTexture2D

var unlocked

func _ready():
	SaveLoad._load()
	if Icon:
		self.icon = Icon 
	unlocked = Name in SaveLoad.SaveFileData.levels_unlocked
	if not unlocked:
		modulate = Color(0.5, 0.5, 0.5)
		remove_theme_stylebox_override("hover")
	else:
		modulate = Color(1, 1, 1)
		add_theme_stylebox_override("hover", StyleBoxEmpty.new())
		
	
func _on_pressed() -> void:
	if unlocked:
		SceneTransition.load_scene(Level)
