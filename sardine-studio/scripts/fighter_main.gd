extends Node2D

@onready var fighter_player: CharacterBody2D = $fighterPlayer
@onready var enemy_placeholder: Enemy = %enemy_placeholder
@onready var count_down: CountDown = $CanvasLayer/CountDown
@onready var main_ui: Control = %"main ui"

@onready var round_1: AudioStreamPlayer2D = $fighterPlayer/round1
@onready var round_2: AudioStreamPlayer2D = $fighterPlayer/round2
@onready var round_3: AudioStreamPlayer2D = $fighterPlayer/round3
@onready var round_4: AudioStreamPlayer2D = $fighterPlayer/round4

func _on_fighter_player_player_hit() -> void:
	#if fighter_player(_on_area_2d_body_entered == true):
		pass
	
# Make a timer
#Reults Screen
func _ready() -> void:
	#delay for player and enemy to fall
	fighter_player.sprite.play("idle")
	enemy_placeholder.sprite_2d.play("i")
	count_down.start_counting()
	fighter_player.set_physics_process(false)
	enemy_placeholder.set_physics_process(false)
	fighter_player.set_process_input(false)
	count_down.counting_finished.connect(
		func() -> void:
			fighter_player.set_physics_process(true)
			enemy_placeholder.set_physics_process(true)
			fighter_player.set_process_input(true)
			enemy_placeholder.sprite_2d.play("idle")
	)
	
	if Gamemanager.enemy == "Ms_E":
		round_4.play()
	elif Gamemanager.enemy == "Boss":
		round_3.play()
	elif Gamemanager.enemy == "Mr_C":
		round_2.play()
	else:
		round_1.play()
