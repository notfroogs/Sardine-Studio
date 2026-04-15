extends Node

var last_battle_won = false

var introsignal = false
var adelinetalk_1 = false
var samtalk_1 = false
var veronicatalk_1 = false
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	var scene_name = get_tree().current_scene.name
