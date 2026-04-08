extends Node2D

@onready var start_button: Button = %StartButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	start_button.pressed.connect(start)
	quit_button.pressed.connect(quit)
	
func start():
	NavigationManager.go_to_level("garage", null)
	
func quit():
	get_tree().quit()
