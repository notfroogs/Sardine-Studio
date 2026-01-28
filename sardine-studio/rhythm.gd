extends Control

@export var chart_text := "res://chart1.txt"
@onready var note_column_1: TextureRect = %NoteColumn1
@onready var note_column_2: TextureRect = %NoteColumn2

@onready var loaded_file := FileAccess.open(chart_text, FileAccess.READ)
@onready var keys = (loaded_file.get_line()).split(",")

@onready var timer1: Timer = $Timer
@onready var timer2: Timer = $Timer2
const NOTE = preload("uid://dilpgmxld0ree")

var chart :Dictionary= {}
var note_progress

@onready var columns = {
	1: note_column_1,
	2: note_column_2,
}

func _ready():
	#timer1.timeout.connect(generate)
	#timer2.timeout.connect(generate_red)
	
	if loaded_file != null:
		chart = store_notes()
		loaded_file.close()
		
	note_progress = chart.duplicate()
	#print("1:   " + str(note_progress))
	
func store_notes():
	var current_note = {}
	var current_line = loaded_file.get_line()
	#print(current_line)
	
	if len(current_line) == 0:
		return "END"
		
	var current_line_array = current_line.split(",")

	for i in len(keys):
		current_note[keys[i].strip_edges()] = current_line_array[i].strip_edges()
	current_note["Next"] = store_notes()
	#print(current_note)
	return current_note
	
var time_elasped : float


func generate() -> void:
	var icon = NOTE.instantiate()
	match int(note_progress["Column"]):
		1:
			columns[1].add_child(icon)
		2:
			columns[2].add_child(icon)
		3:
			pass
		4:
			pass
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

	
	#print(note_progress)
	
	if float(note_progress["Time"]) < time_elasped:
		time_elasped = 0.0
		#print(note_progress)
		if type_string(typeof(note_progress["Next"])) == "Dictionary":
			generate()
			note_progress = note_progress["Next"]
		elif note_progress["Next"] == "END":
			get_tree().quit()

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
