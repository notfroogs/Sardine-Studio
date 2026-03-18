extends Node


const garage_level = preload("res://overworld/scene/garage.tscn")
const street_level = preload("res://overworld/scene/overworld_street.tscn")
const overworld_level = preload("res://overworld/scene/overworld.tscn")

 
signal on_trigger_player_spawn
var spawn_tag

var previous_level

func go_to_level(level_tag, destination_tag):
	var scene_to_load
	match level_tag:
		"garage":
			scene_to_load = garage_level
		"overworld_street":
			scene_to_load = street_level
		"overworld":
			scene_to_load = overworld_level
	if scene_to_load != null:
		print("going to " + str(destination_tag))
		spawn_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)
	else:
		print("scene is null")

func trigger_player_spawn(position:Vector2):
	print("player spawn triggered at" + str(position))
	on_trigger_player_spawn.emit(position)
