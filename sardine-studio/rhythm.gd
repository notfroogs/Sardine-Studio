extends Control

@export var chart_text := "res://chart1.txt"
@onready var note_column_1: TextureRect = %NoteColumn1
@onready var note_column_2: TextureRect = %NoteColumn2
@onready var note_column_3: TextureRect = %NoteColumn3
@onready var note_column_4: TextureRect = %NoteColumn4
@onready var column_empty: TextureRect = %ColumnEmpty

@onready var loaded_file := FileAccess.open(chart_text, FileAccess.READ)
@onready var keys = (loaded_file.get_line()).split(",")

const NOTE = preload("uid://dilpgmxld0ree")

var chart :Dictionary= {}
var note_progress
var time_count : float
@onready var columns = {
	1: note_column_1,
	2: note_column_2,
	3: note_column_3,
	4: note_column_4,
	0: column_empty
}

func _ready():
	#timer1.timeout.connect(generate)
	#timer2.timeout.connect(generate_red)
	
	if loaded_file != null:
		chart = store_notes()
		loaded_file.close()
		
	note_progress = chart.duplicate()
	time_count = float(note_progress["Time"])
	
func store_notes() -> Dictionary:
	var current_note = {}
	var current_line = loaded_file.get_line()
	#print(current_line)
	
	if current_line == "END":
		return {"Time": 5.0,
		"Column": 10,
		"Next": "END"
		}
		
	var current_line_array = current_line.split(",")

	for i in len(keys):
		current_note[keys[i].strip_edges()] = current_line_array[i].strip_edges()
	current_note["Next"] = store_notes()
	#print(current_note)
	return current_note
	
var time_elasped : float


func generate() -> void:
	var icon = NOTE.instantiate()
	print(note_progress)
	if int(note_progress["Column"]) == 10:
		return
	columns[int(note_progress["Column"])].add_child(icon)
	icon.position.x = icon.time * 300.0

func _process(delta: float) -> void:
	time_elasped += delta
	
	for column in columns.values():
		for note in column.get_children():
			note.time -= delta
			note.position.x = note.time * 300.0
	
	
	for column in columns.values():
		if column.get_child_count() != 0:
			miss_check(column.get_child(0))
	
	#if the time 
	if time_count < time_elasped:
		time_elasped = 0.0
		generate()
		if type_string(typeof(note_progress["Next"])) == "Dictionary":
			note_progress = note_progress["Next"]
			time_count = float(note_progress["Time"])
		elif note_progress["Next"] == "END":
			print("waiting")
			await get_tree().create_timer(5.0).timeout
			get_tree().quit()

func miss_check(note) -> void:
	if note == null:
		return
	if note.time < -0.55:
		note.queue_free()
		print("missed")

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
	if input_check(current_note):
		columns[column_index].get_child(0).queue_free()
		


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
