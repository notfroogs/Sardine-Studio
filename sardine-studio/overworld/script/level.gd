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

	if Gamemanager.dialogue_is_active == true:
		player_overworld.set_physics_process(false)
	else:
		player_overworld.set_physics_process(true)
		
	if self.name == "overworld" and not Gamemanager.intro_shown:
		Gamemanager.intro_shown = true
		Gamemanager.intro = true
		DialogueManager.show_dialogue_balloon(preload("res://dialouge/new_dialogue/introround.dialogue"), "start")
	if Gamemanager.first_round_intro == false and Gamemanager.first_round_middle == true:
		Gamemanager.first_round_middle = false
		DialogueManager.show_dialogue_balloon(preload("res://dialouge/new_dialogue/introround.dialogue"), "after")

	
func _on_level_spawn(destination_tag:String):
	var door_path = "Garagedoor_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position)
	
func _process(delta: float) -> void:
	var scene_name = get_tree().current_scene.name
	NavigationManager.previous_level = scene_name
	
	#print(Gamemanager.dialogue_is_active)
	if Gamemanager.dialogue_is_active == true:
		player_overworld.set_physics_process(false)
		
	elif Gamemanager.dialogue_is_active == false:
		player_overworld.set_physics_process(true)
		
	if Gamemanager.tutorial == true:
		Gamemanager.tutorial = false
		#print(NavigationManager.previous_level)
		#DialogueManager.dialogue_ended.emit()
		get_tree().change_scene_to_file("res://rhythm/rhythm_test.tscn")
	if Gamemanager.first_round_intro == true:
		Gamemanager.first_round_intro = false
		Gamemanager.first_round_middle = true
		get_tree().change_scene_to_file("res://rhythm/rhythm_test.tscn")
	if Gamemanager.first_round_middle_fight == true:
		Gamemanager.first_round_middle_fight = false
		get_tree().change_scene_to_file("res://scenes/fighter_main.tscn")
	
