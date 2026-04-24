extends CanvasLayer

@onready var text: TextEdit = %TextEdit
@onready var text_2: TextEdit = %TextEdit2
@onready var button: Button = %Button
@onready var tutorial_panel: Control = %tutorial_panel

func _ready() -> void:
	button.button_down.connect(cancel)
	var scene_name = get_tree().current_scene.name
	
	match scene_name:
		"":
			pass
		_:
			tutorial_panel.visible = false
			

func cancel():
	tutorial_panel.visible = false
	game_start.emit()

signal game_start
