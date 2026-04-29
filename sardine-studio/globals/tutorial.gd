extends Control

@onready var text: TextEdit = %TextEdit
@onready var text_2: TextEdit = %TextEdit2
@onready var got_it_button: Button = %Button
@onready var tutorial_panel: Control = %tutorial_panel


func _ready() -> void:
	PauseScreen.help.connect(edit_tutorial)
	
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



func edit_tutorial(scene_name):
	
	if scene_name == null:
		scene_name = get_tree().current_scene.name
	
	match scene_name:
		"rhythm_test":
			self.visible = true
			text.text = "D for the first column\nF for the second column\nJ 
K"
			text_2.text = "Press buttons when the note is on the shade to get high score!"
		
		"fighterMain":
			self.visible = true
			text.text = "A/left arrow and D/right
to move left/right
X to attack, C to defend,
Space to jump"
			text_2.text = "Beat that hotdog man!"
		_:
			self.visible = true
			text.text = ""
			text_2.text = "Walk around and talk to other people"
			
