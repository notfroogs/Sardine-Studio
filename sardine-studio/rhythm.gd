extends Control

#get the chart "res://chart2.txt"
@export var chart_text := "res://chart1.txt"
#instantiate nodes
@onready var note_column_1: TextureRect = %NoteColumn1
@onready var note_column_2: TextureRect = %NoteColumn2
@onready var note_column_3: TextureRect = %NoteColumn3
@onready var note_column_4: TextureRect = %NoteColumn4
@onready var column_empty: TextureRect = %ColumnEmpty
#instantiate the rhythm game
@onready var loaded_file := FileAccess.open(chart_text, FileAccess.READ)
@onready var keys = (loaded_file.get_line()).split(",")
const NOTE = preload("uid://dilpgmxld0ree")

#set up variables
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

var good_count : int = 0
var great_count : int = 0
var prefect_count : int = 0

func _ready():
	#in case of error
	if loaded_file != null:
		#convert the document into dictionary
		chart = store_notes()
		loaded_file.close()
		
	note_progress = chart.duplicate()
	#Start the timer
	time_count = float(note_progress["Time"])
	
#It's a recursive function so that we can store everything in a dictionary
func store_notes() -> Dictionary:
	#get the current line and turn it into a dictionary
	var current_note = {}
	var current_line = loaded_file.get_line()
	##print(current_line)
	
	#special case for the end
	if current_line == "END":
		return {"Time": 5.0,
		"Column": 10,
		"Next": "END"
		}
		
	#split the line into an array
	var current_line_array = current_line.split(",")
	#and use iteration to store them with corresponding key
	for i in len(keys):
		current_note[keys[i].strip_edges()] = current_line_array[i].strip_edges()
	#recur
	current_note["Next"] = store_notes()
	return current_note

#function for generating note
func generate() -> void:
	#check if the note is ending
	if type_string(typeof(note_progress["Next"])) == "String":
		if note_progress["Next"] == "END":
			return
	
	var icon = NOTE.instantiate()
	#set up the speed and add them to corresponse column
	icon.speed = float(note_progress["Speed"])/10.0
	columns[int(note_progress["Column"])].add_child(icon)
	icon.position.x = 1000.0
	
	if note_progress["Duration"] != "#":
		var color_rect := ColorRect.new()
		color_rect.size = Vector2(128, 128)
		color_rect.size.x = 128.0 + icon.speed * float(note_progress["Duration"])
		icon.add_child(color_rect)
	
	#immediately generate the next note if Skip is Yes
	if note_progress["Skip"] == "Yes":
		note_progress = note_progress["Next"]
		generate()

var time_elasped : float

func _process(delta: float) -> void:
	#record how much time had passed
	time_elasped += delta
	
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
		#move the current note to the next note
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
	if note.position.x < -130.0:
		note.queue_free()
		print("missed")

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
		columns[column_index].get_child(0).queue_free()

func input_check(note) -> bool:
	#if the note is intersect with the parent note
	if note.position.x >= -128 and note.position.x <= 128:
		#if the position is NOT between -64 and 64
		if note.position.x <= -64 or note.position.x >= 64:
			print("good")
		#if the position is NOT between -32 and 32
		elif note.position.x <= -32 or note.position.x >= 32:
			print("great")
		else:
			print("prefect")
		#return true anyway if the note is intersect with the parent note
		return true
	return false
