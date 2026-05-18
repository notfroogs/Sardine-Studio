extends Node

# triggers for gameplay.
var last_battle_won = false
var dialogue_is_active = false

#Triggers for story
var begin = false
var begin_end = false
var after_tut = false
var start = true
var intro = false
var intro_shown = false
var tutorial = false
var first_round_intro = false
var first_round_middle = false
var first_round_middle_fight = false
var first_round_ending = false
var day_2 = false
var second_round = false
var third_round = false
var practice = false
var explore = false
var fight_the_dumb_hotdog = false

#2 for Ms E
#6 for Mr Peery
var number_of_days = 10

var enter_venue = false
var fight_elle = false
var playing_the_game_idk = false
var round_3_start = false

var fight_creegan = false
var the_dog = false


var fighter_tutorial = false
var music_tutorial = false

var enemy = "red_hot_dog"
var chart

func change_to_fight():
	get_tree().change_scene_to_file("res://scenes/fighter_main.tscn")
	if number_of_days == 2:
		enemy = "Ms_E"
	elif number_of_days == 6:
		enemy = "Boss"
	elif number_of_days == 10:
		enemy = "Mr_C"
	else:
		enemy = "red_hot_dog"
	
	if !fighter_tutorial:
		PauseScreen.tutorial.edit_tutorial("fighterMain")
		get_tree().paused = true
		PauseScreen.tutorial.got_it_button.pressed.connect(unpause, CONNECT_ONE_SHOT)
		fighter_tutorial = true

func change_to_rhythm():
	get_tree().change_scene_to_file("res://rhythm/rhythm_test.tscn")
	if number_of_days == 1:
		pass
	
	if !music_tutorial:
		PauseScreen.tutorial.edit_tutorial("rhythm_test")
		get_tree().paused = true
		PauseScreen.tutorial.got_it_button.pressed.connect(unpause, CONNECT_ONE_SHOT)
		music_tutorial = true


func unpause():
	get_tree().paused = false


# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass
