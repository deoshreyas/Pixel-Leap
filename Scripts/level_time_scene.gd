@tool
extends HBoxContainer

@export var active = true 
@export var level : CompressedTexture2D:
	set(value):
		level = value 
		$TextureRect.texture = level 
		notify_property_list_changed()
@export var time : float:
	set(value):
		time = value 
		$RichTextLabel.text = str(time)
		notify_property_list_changed()

func _ready():
	if not active:
		$TextureRect.modulate = Color(0.5, 0.5, 0.5)
