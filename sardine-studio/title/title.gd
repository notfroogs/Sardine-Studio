extends Node2D

@onready var start_button: Button = %StartButton
@onready var quit_button: Button = %QuitButton
@onready var selectsound: AudioStreamPlayer2D = $selectsound

func _ready() -> void:
	start_button.pressed.connect(start)
	quit_button.pressed.connect(quit)
	
func start():
	#NavigationManager.go_to_level("garage", null)
	selectsound.play()
	await selectsound.finished
	get_tree().change_scene_to_file("res://dialouge/Introcutscene.tscn")
	
func quit():
	selectsound.play()
	await selectsound.play()
	get_tree().quit()
