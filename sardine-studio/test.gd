extends Node2D

const RHYTHM = preload("uid://ceb5dbeodb5xh")
@onready var button: Button = %Button
@onready var rhythm_layer: CanvasLayer = %RhythmLayer

func _on_button_button_down() -> void:
	button.visible = false
	var rhythm_game = RHYTHM.instantiate()
	rhythm_game.chart_text = "res://chart1.txt"
	rhythm_layer.add_child(rhythm_game)
	rhythm_game.Rhythm_Game_Ended.connect(_on_Rhythm_Game_Ended)

func _on_Rhythm_Game_Ended() -> void:
	var rhythm_game = get_node("RhythmLayer/rhythm")
	#var tween = get_tree().create_tween()
	#tween.tween_property(rhythm_game, "modulate", Color(34,34,34), 0.6)
	
	await get_tree().create_timer(5.0).timeout
	rhythm_game.queue_free()
	button.visible = true
