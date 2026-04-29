extends Node

var last_battle_won = false

var fighter_tutorial = false
var music_tutorial = false

func change_to_fight():
	get_tree().change_scene_to_file("res://scenes/fighter_main.tscn")
	if !fighter_tutorial:
		PauseScreen.tutorial.edit_tutorial("fighterMain")
		get_tree().paused = true
		PauseScreen.tutorial.got_it_button.pressed.connect(unpause, CONNECT_ONE_SHOT)
		fighter_tutorial = true
		

func change_to_rhythm():
	get_tree().change_scene_to_file("res://rhythm/rhythm_test.tscn")
	if !music_tutorial:
		PauseScreen.tutorial.edit_tutorial("rhythm_test")
		get_tree().paused = true
		PauseScreen.tutorial.got_it_button.pressed.connect(unpause, CONNECT_ONE_SHOT)
		music_tutorial = true

func unpause():
	get_tree().paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
