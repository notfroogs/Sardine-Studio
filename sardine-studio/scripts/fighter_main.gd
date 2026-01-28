extends Node2D

@onready var fighter_player: CharacterBody2D = $fighterPlayer
@onready var enemy_placeholder: CharacterBody2D = $"enemy placeholder"

func _on_fighter_player_player_hit() -> void:
#	if fighter_player(_on_area_2d_body_entered == true):
		pass
	
