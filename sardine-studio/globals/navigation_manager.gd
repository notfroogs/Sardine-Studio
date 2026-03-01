extends Node


const garage_level = preload("res://overworld/scene/garage.tscn")
const street_level = preload("res://overworld/scene/overworld_street.tscn")

signal on_trigger_player_spawn
var spawn_tag

func go_to_level(level_tag, destination_tag):
	var scene_to_load
	
	match level_tag:
		"garage":
			scene_to_load = garage_level
		"overworld_street":
			scene_to_load = street_level
	if scene_to_load != null:
		spawn_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)

func trigger_player_spawn(position:Vector2):
	on_trigger_player_spawn.emit(position)
