extends Node2D

const RHYTHM = preload("uid://ceb5dbeodb5xh")
@onready var button: Button = %Button

func _on_button_button_down() -> void:
	button.visible = false
	var rhythm_game = RHYTHM.instantiate()
	rhythm_game.chart_text = "res://chart1.txt"
	add_child(rhythm_game)
	rhythm_game.Rhythm_Game_Ended.connect(_on_Rhythm_Game_Ended)

func _on_Rhythm_Game_Ended() -> void:
	get_node("rhythm").queue_free()
	button.visible = true
