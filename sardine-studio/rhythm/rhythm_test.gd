extends Node2D

const RHYTHM = preload("uid://ceb5dbeodb5xh")
@onready var button: Button = %Button
@onready var rhythm_layer: CanvasLayer = %RhythmLayer
@onready var shader: ColorRect = %Shader
@onready var labels: VBoxContainer = %Labels
@onready var score: Label = %Score
@onready var finish_button: Button = %FinishButton
@onready var count_down: CountDown = $RhythmLayer/CountDown

func _on_button_button_down() -> void:
	button.visible = false
	var rhythm_game = RHYTHM.instantiate()
	rhythm_game.chart_text = "res://rhythm/chart1.txt"
	rhythm_layer.add_child(rhythm_game)
	rhythm_game.Rhythm_Game_Ended.connect(_on_Rhythm_Game_Ended)

var tween : Tween
var blur_material : ShaderMaterial

func _on_Rhythm_Game_Ended(array) -> void:
	var rhythm_game = get_node("RhythmLayer/rhythm")
	get_node("RhythmLayer").move_child(rhythm_game, 2)
	
	await get_tree().create_timer(1.0).timeout
	
	if shader.material is ShaderMaterial:
		blur_material = shader.material
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		tween.tween_method(update_Blur, 0, 2, 0.8)
		
	await tween.finished
	
	labels.visible = true
	var j = 0
	for i in array:
		var label = labels.get_child(j) 
		label.text = label.name + ": " + str(i)
		j += 1
	var MCM
	if array[4] <= 10:
		MCM = 1
	elif array[4] <= 20:
		MCM = 1.25
	elif array[4] <= 30:
		MCM = 1.5
	else:
		MCM = 2
	var final_score = (array[0] * 100 + array[1] *150 + array[2] * 200) * MCM
	score.text = "Final Score: " + str(int(floor(final_score)))
	
	finish_button.visible = true
	score.visible = true
	
	#await get_tree().create_timer(2.0).timeout
	await finish_button.pressed
	update_Blur(0)
	rhythm_game.queue_free()
	finish_button.visible = false
	score.visible = false
	labels.visible = false
	
	if NavigationManager.previous_level != null:
		NavigationManager.go_to_level(NavigationManager.previous_level, null)
	else:
		button.visible = true

func update_Blur(value: float):
	blur_material.set_shader_parameter("lod", value)

func _ready() -> void:
	
	var rhythm_game = RHYTHM.instantiate()
	rhythm_game.chart_text = "res://rhythm/chart1.txt"
	rhythm_layer.add_child(rhythm_game)
	rhythm_game.Rhythm_Game_Ended.connect(_on_Rhythm_Game_Ended)
	rhythm_game.process_mode = Node.PROCESS_MODE_DISABLED
	rhythm_game.music.stream_paused = true
	
	count_down.start_counting()
	
	count_down.counting_finished.connect(
		func() -> void:
			rhythm_game.process_mode = Node.PROCESS_MODE_INHERIT
			rhythm_game.music.stream_paused = false
	)
