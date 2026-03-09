extends Node2D

const RHYTHM = preload("uid://ceb5dbeodb5xh")
@onready var button: Button = %Button
@onready var rhythm_layer: CanvasLayer = %RhythmLayer
@onready var shader: ColorRect = %Shader
@onready var labels: VBoxContainer = %Labels

func _on_button_button_down() -> void:
	button.visible = false
	var rhythm_game = RHYTHM.instantiate()
	rhythm_game.chart_text = "res://chart1.txt"
	rhythm_layer.add_child(rhythm_game)
	rhythm_game.Rhythm_Game_Ended.connect(_on_Rhythm_Game_Ended)

var tween : Tween
var blur_material : ShaderMaterial

func _on_Rhythm_Game_Ended() -> void:
	#var rhythm_game = get_node("RhythmLayer/rhythm")
	
	await get_tree().create_timer(1.0).timeout
	if shader.material is ShaderMaterial:
		blur_material = shader.material
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		tween.tween_method(update_Blur, 0, 2.5, 0.8)
		
	await get_tree().create_timer(5.0).timeout
	#rhythm_game.queue_free()
	button.visible = true

func update_Blur(value: float):
	blur_material.set_shader_parameter("lod", value)

func _ready() -> void:
	#labels.separation = 20
	pass
	#if shader.material is ShaderMaterial:
		#print("yes")
		#blur_material = shader.material
		##print(blur_material.get_shader_parameter("lod"))
		#
		#if tween:
			#tween.kill()
		#tween = get_tree().create_tween()
		#tween.tween_method(update_Blur, 0, 2.5, 0.8)
