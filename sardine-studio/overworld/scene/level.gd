extends Node2D

func _ready():
	if NavigationManager.spawn_tag != null:
		_on_level_spawn(NavigationManager.spawn_tag)
	
func _on_level_spawn(destination_tag: String):
	var door_path = "Garagedoor_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position)
