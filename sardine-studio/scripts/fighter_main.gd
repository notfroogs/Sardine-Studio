extends Node2D

@onready var fighter_player: CharacterBody2D = $fighterPlayer
@onready var enemy_placeholder: CharacterBody2D = $"enemy placeholder"
@onready var count_down: CountDown = $CanvasLayer/CountDown

func _on_fighter_player_player_hit() -> void:
	#if fighter_player(_on_area_2d_body_entered == true):
		pass
	
# Make a timer
#Reults Screen
func _ready() -> void:
	#delay for player and enemy to fall
	count_down.start_counting()
	fighter_player.set_physics_process(false)
	enemy_placeholder.set_physics_process(false)
	count_down.counting_finished.connect(
		func() -> void:
			fighter_player.set_physics_process(true)
			enemy_placeholder.set_physics_process(true)
	)
	
