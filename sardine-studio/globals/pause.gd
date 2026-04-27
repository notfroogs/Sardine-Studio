extends Node

var pausing : bool = false
@onready var pause_screen: Control = $PauseScreen

func _ready() -> void:
	#get the buttons in the pause control node and control them to their functions
	pause_screen.get_resume_button().button_down.connect(pause)
	pause_screen.get_quit_button().button_down.connect(exit)
	pause_screen.get_help_button().button_down.connect(send_help)

func _input(event: InputEvent) -> void:
	print(event)
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
				self.visible = true
				get_tree().paused = true
	else:
		match scene_name:
			"":
				pass
			_:
				self.visible = false
				get_tree().paused = false

func exit() -> void:
	get_tree().quit()

signal help

func send_help():
	help.emit()
