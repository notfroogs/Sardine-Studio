extends Control

@export var chart_text := "res://chart1.txt"
@onready var note_column_1: TextureRect = %NoteColumn1
@onready var note_column_2: TextureRect = %NoteColumn2

@onready var timer1: Timer = $Timer
@onready var timer2: Timer = $Timer2
const NOTE = preload("uid://dilpgmxld0ree")

var dictionary := {}

func _ready():
	#timer1.timeout.connect(generate)
	#timer2.timeout.connect(generate_red)
	var loaded_file := FileAccess.open(chart_text, FileAccess.READ)
	if loaded_file:
		
		var items = (loaded_file.get_line()).split(",")
		
		while not loaded_file.eof_reached():
			var contents = loaded_file.get_line().split(",")

				
	
func store_notes(items, line):
	var current_note = {}
	for i in range(items.len()):
		current_note[items[i].strip_edges()] = line[i].strip_edges()
		current_note["Next"] = store_notes()
	return current_note
	
func generate() -> void:
	var icon = NOTE.instantiate()
	note_column_1.add_child(icon)
	#print(typeof(icon))
	icon.position.x = icon.time * 300.0

func generate_red() -> void:
	var icon = NOTE.instantiate()
	note_column_2.add_child(icon)
	icon.position.x = icon.time * 300.0

func _process(delta: float) -> void:
	for note in note_column_1.get_children():
		note.time -= delta
		note.position.x = note.time * 300.0
		
	for note in note_column_2.get_children():
		note.time -= delta
		note.position.x = note.time * 300.0
	
	if note_column_1.get_child_count() != 0:
		miss_check(note_column_1.get_child(0))
	if note_column_2.get_child_count() != 0:
		miss_check(note_column_2.get_child(0))

func miss_check(note) -> void:
	if note == null:
		return
	if note.time < -0.55:
		note.queue_free()
		print("missed")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("white_node_press"):
		var current_note := note_column_1.get_child(0)
		if current_note == null:
			return
		if input_check(current_note):
			note_column_1.get_child(0).queue_free()
			
	elif event.is_action_pressed("red_node_press"):
		var current_note := note_column_2.get_child(0)
		if current_note == null:
			return
		if input_check(current_note):
			note_column_2.get_child(0).queue_free()
		

func input_check(note) -> bool:
	if note.time >= -0.5 and note.time <= 0.5:
		#print(note.time)
		#if time is NOT between -0.3 and 0.3
		if note.time <= -0.3 or note.time >= 0.3:
			print("good")
		#if time is NOT between -0.05 and 0.05
		elif note.time <= -0.05 or note.time >= 0.05:
			print("great")
		else:
			print("prefect")
		#return true anyway if time is between -0.5 and 0.5
		return true
	return false
