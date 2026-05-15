extends Node

#@onready var spawn: Marker2D = $Garagedoor_A/spawn
@onready var player_overworld: playerO = $playerOverworld
@export var spawn_default: Marker2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("loading into " + self.name)
	if (spawn_default != null):
		player_overworld.global_position = spawn_default.global_position
	if NavigationManager.spawn_tag != null:
		_on_level_spawn(NavigationManager.spawn_tag)


## WHEN CUTSCENE PLAYS STOP PLAYER MOVEMENT 
	if Gamemanager.dialogue_is_active == true:
		player_overworld.set_physics_process(false)
	else:
		player_overworld.set_physics_process(true)
		
		
		
	# CUTSCENE TRIGGERS
	if self.name == "garage" and not Gamemanager.begin:
		Gamemanager.begin = true
		DialogueManager.show_dialogue_balloon(preload("res://dialouge/new_dialogue/introround.dialogue"), "intro")
		#if Gamemanager.begin = true:
			
	if self.name == "overworld" and not Gamemanager.intro_shown:
		Gamemanager.intro_shown = true
		Gamemanager.intro = true
		DialogueManager.show_dialogue_balloon(preload("res://dialouge/new_dialogue/introround.dialogue"), "start")
	
	if Gamemanager.first_round_intro == false and Gamemanager.first_round_middle == true:
		Gamemanager.first_round_middle = false
		DialogueManager.show_dialogue_balloon(preload("res://dialouge/new_dialogue/introround.dialogue"), "after")
	
	if Gamemanager.first_round_ending == true:
		Gamemanager.first_round_ending = false
		DialogueManager.show_dialogue_balloon(preload("res://dialouge/new_dialogue/introround.dialogue"), "ending")
		await DialogueManager.dialogue_ended
		get_tree().change_scene_to_file("res://overworld/scene/garage.tscn")
		Gamemanager.day_2 = true
	
	if Gamemanager.day_2 == true:
		Gamemanager.day_2 = false
		Gamemanager.number_of_days = 1
		DialogueManager.show_dialogue_balloon(preload("res://dialouge/new_dialogue/second_round.dialogue"),"start")
		#DialogueManager.show_dialogue_balloon()
	
	if Gamemanager.after_tut == true:
		Gamemanager.after_tut = false
		DialogueManager.show_dialogue_balloon(preload("res://dialouge/new_dialogue/introround.dialogue"),"after_tut")
	
	if self.name == "overworld" and Gamemanager.start:
		Gamemanager.start = false
	
	if self.name == "overworld" and Gamemanager.enter_venue:
		Gamemanager.enter_venue = false
		Gamemanager.number_of_days = 2
		DialogueManager.show_dialogue_balloon(preload("res://dialouge/new_dialogue/second_round.dialogue"), "Venue")
	
	if self.name == "overworld" and Gamemanager.number_of_days == 1:
		Gamemanager.enter_venue = true
	
	if self.name == "overworld" and Gamemanager.playing_the_game_idk == true and Gamemanager.number_of_days == 2:
		Gamemanager.playing_the_game_idk = false
		DialogueManager.show_dialogue_balloon(preload("res://dialouge/new_dialogue/second_round.dialogue"), "Postfight")
		await DialogueManager.dialogue_ended
		get_tree().change_scene_to_file("res://overworld/scene/garage.tscn")
		Gamemanager.number_of_days = 4
		return
		
	if self.name == "garage" and Gamemanager.number_of_days == 4:
		Gamemanager.round_3_start = true
		
	if self.name == "garage" and Gamemanager.round_3_start == true:
		Gamemanager.round_3_start = false
		DialogueManager.show_dialogue_balloon(preload("res://dialouge/new_dialogue/third_round.dialogue"), "start")
	
	if self.name == "overworld" and Gamemanager.number_of_days == 4:
		Gamemanager.the_dog = true
		
	if self.name == "overworld" and Gamemanager.the_dog == true:
		Gamemanager.the_dog = false
		print(self.name)
		Gamemanager.number_of_days = 6
		DialogueManager.show_dialogue_balloon(preload("res://dialouge/new_dialogue/third_round.dialogue"),"idk_what_this_is")
		
		
	if self.name == "overworld" and Gamemanager.playing_the_game_idk == true and Gamemanager.number_of_days == 6:
		Gamemanager.playing_the_game_idk = false
		DialogueManager.show_dialogue_balloon(preload("res://dialouge/new_dialogue/third_round.dialogue"), "after_fight_creegan_idk")
		await DialogueManager.dialogue_ended
		get_tree().change_scene_to_file("res://overworld/scene/overworld_street.tscn")
		DialogueManager.show_dialogue_balloon(preload("res://dialouge/new_dialogue/fourth_round.dialogue"),"start")
		


func _on_level_spawn(destination_tag:String):
	var door_path = "Garagedoor_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position)
	
func _process(delta: float) -> void:
	var scene_name = get_tree().current_scene.name
	NavigationManager.previous_level = scene_name
	
	
	## CUTSCENE TRIGGERS
	#print(Gamemanager.dialogue_is_active)
	if Gamemanager.dialogue_is_active == true:
		player_overworld.set_physics_process(false)
		
	elif Gamemanager.dialogue_is_active == false:
		player_overworld.set_physics_process(true)
		
	if Gamemanager.tutorial == true:
		Gamemanager.tutorial = false
		#print(NavigationManager.previous_level)
		#DialogueManager.dialogue_ended.emit()
		#get_tree().change_scene_to_file("res://rhythm/rhythm_test.tscn")
		Gamemanager.change_to_rhythm()
		
		
	if Gamemanager.first_round_intro == true:
		Gamemanager.first_round_intro = false
		Gamemanager.first_round_middle = true
		#get_tree().change_scene_to_file("res://rhythm/rhythm_test.tscn")
		Gamemanager.change_to_rhythm()
		
	if Gamemanager.first_round_middle_fight == true:
		Gamemanager.first_round_middle_fight = false
		Gamemanager.first_round_ending = true
		#get_tree().change_scene_to_file("res://scenes/fighter_main.tscn")
		Gamemanager.change_to_fight()
		
	if Gamemanager.begin_end == true:
		Gamemanager.begin_end = false
		#get_tree().change_scene_to_file("res://rhythm/rhythm_test.tscn")
		Gamemanager.after_tut = true
		Gamemanager.change_to_rhythm()
		
		
	if Gamemanager.fight_the_dumb_hotdog == true:
		Gamemanager.fight_the_dumb_hotdog = false
		Gamemanager.change_to_fight()
	
	#if Gamemanager.number_of_days == 4 and Gamemanager.the_dog == true:
		#Gamemanager.the_dog = false
		#DialogueManager.show_dialogue_balloon(preload("res://dialouge/new_dialogue/third_round.dialogue"),"idk_what_this_is")
