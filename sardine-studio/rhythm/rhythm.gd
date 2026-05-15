extends Control

#get the chart "res://chart2.txt"
@export var chart_text := "res://rhythm/chart1.txt"
#instantiate nodes
@onready var note_column_1: TextureRect = %NoteColumn1
@onready var note_column_2: TextureRect = %NoteColumn2
@onready var note_column_3: TextureRect = %NoteColumn3
@onready var note_column_4: TextureRect = %NoteColumn4
@onready var column_empty: TextureRect = %ColumnEmpty
#instantiate the rhythm game
@onready var loaded_file := FileAccess.open(chart_text, FileAccess.READ)
@onready var keys = (loaded_file.get_line()).split(",")

@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var music: AudioStreamPlayer = %Music

var in_game = true

#set up variables
var chart = []
var note_progress := 0
var time_count : float
@onready var columns = {
	1: note_column_1,
	2: note_column_2,
	3: note_column_3,
	4: note_column_4,
	0: column_empty
}
const RHYTHMGREENDOT = preload("uid://cxv8yev7hgsfc")
const RHYTHMORANGEDOT = preload("uid://ty87ir8k6jrj")
const RHYTHMPURPLEDOT = preload("uid://c5seb2rcjutfx")
const RHYTHMREDDOT = preload("uid://dviwl7m2fn0dl")
const NOTE = preload("uid://dilpgmxld0ree")

@onready var notes = {
	1: RHYTHMGREENDOT,
	2: RHYTHMORANGEDOT,
	3: RHYTHMPURPLEDOT,
	4: RHYTHMREDDOT,
	0: NOTE
}


signal Rhythm_Game_Ended

var missed_count : int = 0
var good_count : int = 0
var great_count : int = 0
var perfect_count : int = 0
var combo : int = 0

@onready var scoring_container: VBoxContainer = %ScoringContainer
@onready var combo_text: RichTextLabel = %ComboText
@onready var scoring_text: RichTextLabel = %ScoringText

func _ready():
	#in case of file error
	if loaded_file != null:
		#convert the document into dictionary
		store_note()
		loaded_file.close()
	
	
	
	#Start the timer
	time_count = float(chart[note_progress]["Time"])

func store_note():
	#iterate until there are no more line that hadn't been read
	while loaded_file.get_position() < loaded_file.get_length():
		var current_note = {}
		var current_line = loaded_file.get_line()
		if current_line == "END":
			break
		#split the line into an array
		var current_line_array = current_line.split(",")
		#and use iteration to store them with corresponding key
		for i in len(keys):
			current_note[keys[i].strip_edges()] = current_line_array[i].strip_edges()
		
		#append the dictionary into the array
		chart.append(current_note)
	chart.append("END")

#function for generating note
func generate() -> void:
	#check if the note is ending
	if type_string(typeof(chart[note_progress])) == "String":
		if chart[note_progress] == "END":
			return
	
	var column_number = int(chart[note_progress]["Column"])
	
	var icon = NOTE.instantiate()
	icon.texture = notes[column_number]
	#set up the speed and add them to corresponse column
	icon.speed = float(chart[note_progress]["Speed"])/10.0
	columns[column_number].add_child(icon)
	icon.position.x = 1000.0
	
	if chart[note_progress]["Duration"] != "#":
		var note_bar := TextureRect.new()
		note_bar.size = Vector2(128, 128)
		note_bar.size.x = 128.0 + icon.speed * float(chart[note_progress]["Duration"])
		icon.add_child(note_bar)
	
	#immediately generate the next note if Skip is Yes
	if chart[note_progress]["Skip"] == "Yes":
		note_progress += 1
		generate()

var time_elasped : float

func _process(delta: float) -> void:
	
	#await game_start
	
	#record how much time had passed
	time_elasped += delta
	
	if !in_game:
		return
	
	#iterate through each column and each child and make them move
	for column in columns.values():
		for note in column.get_children():
			note.position.x -= note.speed
	
	#check if the first note in each column is missed
	for column in columns.values():
		if column.get_child_count() != 0:
			miss_check(column.get_child(0))
	
	#if the time_elasped is bigger than the "Time" for the current note 
	if time_count < time_elasped:
		#than reset timer and generate the current note
		time_elasped = 0.0
		generate()
		
		#If there are more note
		if type_string(typeof(chart[note_progress + 1])) == "Dictionary":
			#move the current note to the next note
			note_progress += 1
			time_count = float(chart[note_progress]["Time"])
		#else end the game
		elif chart[note_progress + 1] == "END":
			time_count = 100.0
			await get_tree().create_timer(7.0).timeout
			in_game = false
			print("========")
			print("good: " + str(good_count))
			print("great: " + str(great_count))
			print("perfect: " + str(perfect_count))
			print("missed: " + str(missed_count))
			print("Max Combo: " + str(max_combo))
			Rhythm_Game_Ended.emit([good_count, great_count, perfect_count, missed_count, max_combo])


func miss_check(note) -> void:
	if note == null:
		return
	if note.position.x < -130.0:
		note.queue_free()
		audio_stream_player.volume_db = 5.0
		audio_stream_player.pitch_scale = [0.1, 3.0].pick_random()
		audio_stream_player.play()
		scoring_text.text = "Missed..."
		missed_count += 1
		combo = 0
		combo_check()

#receive input
func _input(event: InputEvent) -> void:
	var column_index : int = 0
	if event.is_action_pressed("note1_pressed"):
		column_index = 1
	elif event.is_action_pressed("note2_pressed"):
		column_index = 2
	elif event.is_action_pressed("note3_pressed"):
		column_index = 3
	elif event.is_action_pressed("note4_pressed"):
		column_index = 4
	
	if column_index == 0:
		return
	
	var current_note = columns[column_index].get_child(0)
	if current_note == null:
		return

	#check if the input is a successful input
	if input_check(current_note):
		if current_note.get_child_count() == 0:
			columns[column_index].get_child(0).queue_free()
		elif current_note.get_child_count() != 0:
			pass

func input_check(note) -> bool:
	#if the note is intersect with the parent note
	if note.position.x >= -128 and note.position.x <= 128:
		#if the position is NOT between -64 and 64
		if note.position.x <= -64 or note.position.x >= 64:
			scoring_text.text = "good"
			good_count += 1
			audio_stream_player.volume_db = [-0.4, 1.6].pick_random()
			audio_stream_player.pitch_scale = [0.5, 1.5].pick_random()
		#if the position is NOT between -32 and 32
		elif note.position.x <= -32 or note.position.x >= 32:
			scoring_text.text = "Great"
			great_count += 1
			audio_stream_player.volume_db = [-0.1, 1.3].pick_random()
			audio_stream_player.pitch_scale = [0.7, 1.3].pick_random()
			
		else:
			scoring_text.text = "Perfect!"
			perfect_count += 1
			audio_stream_player.volume_db = 0
			audio_stream_player.pitch_scale = 1
		#return true anyway if the note is intersect with the parent note
		combo += 1
		audio_stream_player.play()
		text_animation()
		return true
	
	return false

var tween
#var original_position : float = 60

func text_animation() -> void:
	if tween:
		tween.kill()
		#scoring_container.position.y = original_position
		scoring_container.scale = Vector2(1,1)
	combo_check()
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	#tween.parallel().tween_property(scoring_container, "position:y", 40, 0.1)
	tween.tween_property(scoring_container, "scale", Vector2(1.2, 1.2), 0.1)
	#tween.parallel().tween_property(scoring_container, "position:y", 60, 0.1)
	tween.tween_property(scoring_container, "scale", Vector2(1,1), 0.1)

var max_combo : int = 0

func combo_check() -> void:
	var exclamation_marks = ""
	if combo >= 10:
		exclamation_marks = "!!!"
	elif combo >= 5:
		exclamation_marks = "!!"
	elif combo >= 2:
		exclamation_marks = "!"
		
	if combo > max_combo:
		max_combo = combo
	combo_text.text = ("Combo " + str(combo) + exclamation_marks)
	
