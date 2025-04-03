extends Control

@export var AppleCount = true 
@export var CherryCount = true  
@export var BananaCount = true 
@export var KiwiCount = true 
@export var MelonCount = true 
@export var OrangeCount = true 
@export var PineappleCount = true 
@export var StrawberryCount = true 
@export var EnemyCount = true 

var num_collectibles = 0 

func _ready() -> void:
	if not AppleCount:
		$HBoxContainer/Apples.visible = false  
	if not CherryCount:
		$HBoxContainer/Cherries.visible = false 
	if not BananaCount:
		$HBoxContainer/Bananas.visible = false 
	if not KiwiCount:
		$HBoxContainer/Kiwi.visible = false 
	if not MelonCount:
		$HBoxContainer/Melon.visible = false 
	if not OrangeCount:
		$HBoxContainer/Orange.visible = false 
	if not PineappleCount:
		$HBoxContainer/Pineapple.visible = false 
	if not StrawberryCount:
		$HBoxContainer/Strawberry.visible = false 
	if not EnemyCount:
		$HBoxContainer/Enemy.visible = false 

func increment(fruit):
	num_collectibles += 1 
	match fruit:
		"apple":
			%AppleCount.text = str(int(%AppleCount.text)+1)
		"cherry":
			%CherryCount.text = str(int(%CherryCount.text)+1)
		"banana":
			%BananaCount.text = str(int(%BananaCount.text)+1)
		"kiwi":
			%KiwiCount.text = str(int(%KiwiCount.text)+1)
		"melon":
			%MelonCount.text = str(int(%MelonCount.text)+1)
		"orange":
			%OrangeCount.text = str(int(%OrangeCount.text)+1)
		"pineapple":
			%PineappleCount.text = str(int(%PineappleCount.text)+1)
		"strawberry":
			%StrawberryCount.text = str(int(%StrawberryCount.text)+1)
		"enemy":
			%EnemyCount.text = str(int(%EnemyCount.text)+1)
