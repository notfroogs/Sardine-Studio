extends Node

var last_battle_won = false
var dialogue_is_active = false

var intro = false
var tutorial = false
var first_round = false
var second_round = false
var third_round = false


# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	var scene_name = get_tree().current_scene.name
	if Gamemanager.tutorial == true:
		NavigationManager.previous_level = scene_name
		print(NavigationManager.previous_level)
		DialogueManager.dialogue_ended.emit()
		get_tree().change_scene_to_file("res://rhythm/rhythm_test.tscn")
