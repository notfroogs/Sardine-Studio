extends Control

@onready var text: TextEdit = %TextEdit
@onready var text_2: TextEdit = %TextEdit2
@onready var got_it_button: Button = %Button
@onready var tutorial_panel: Control = %tutorial_panel


func _ready() -> void:
	PauseScreen.help.connect(show_tutorial)
	
	got_it_button.pressed.connect(cancel)
	var scene_name = get_tree().current_scene.name
	
	match scene_name:
		"":
			pass
		_:
			#control.visible = false
			pass
			

func cancel():
	self.visible = false
	#game_start.emit()

signal game_start

var is_paused := false

func show_tutorial():
	is_paused = true
	
	var scene_name = get_tree().current_scene.name
	self.visible = true
	#match scene_name:
		#"rhythm_test":
			#control.visible = true
		#_:
			#control.visible = false
			#
