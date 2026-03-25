extends Node

#@onready var spawn: Marker2D = $Garagedoor_A/spawn
@onready var player_overworld: playerO = $playerOverworld
@export var spawn_default: Marker2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (spawn_default != null):
		player_overworld.global_position = spawn_default.global_position
	if NavigationManager.spawn_tag != null:
		_on_level_spawn(NavigationManager.spawn_tag)
		
func _on_level_spawn(destination_tag:String):
	var door_path = "Garagedoor_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position)
