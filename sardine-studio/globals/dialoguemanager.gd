extends Node

var introsignal = false
var adelinetalk_1 = false
var samtalk_1 = false
var veronicatalk_1 = false
# Called when the node enters the scene tree for the first time.
const INTROCUTSCENE = preload("res://dialouge/Introcutscene.tscn")

func _ready() -> void:
	var scene_name = get_tree().current_scene.name
	match scene_name:
		"Title":
			INTROCUTSCENE.set_script("res://dialouge/preround1.gd")
		"garage":
			if Gamemanager.introsignal == true:
				INTROCUTSCENE.set_script("res://dialouge/TestDialouge.gd")
