extends Node

var pausing : bool = false
@onready var pause_screen: Control = $PauseScreen
@onready var tutorial: Control = $Tutorial

func _ready() -> void:
	#get the buttons in the pause control node and control them to their functions
	pause_screen.get_resume_button().button_down.connect(pause)
	pause_screen.get_quit_button().button_down.connect(exit)
	pause_screen.get_help_button().button_down.connect(show_tutorial)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause()

func pause() -> void:
	pausing = !pausing 
	var scene_name = get_tree().current_scene.name
	#print("pasue:" + str(pausing))
		
	if pausing:
		match scene_name:
			#add case if need the puase control do something different for that scene
			"title":
				pass
			_:
				pause_screen.visible = true
				get_tree().paused = true
	else:
		match scene_name:
			"":
				pass
			_:
				pause_screen.visible = false
				tutorial.visible = false
				get_tree().paused = false

func exit() -> void:
	get_tree().quit()

signal help


func show_tutorial():
	var scene_name = get_tree().current_scene.name
	
	help.emit()
	
	match scene_name:
		"rhythm_test":
			tutorial.visible = true
		_:
			tutorial.visible = false
			
