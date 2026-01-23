extends Control

#@export var chart : Dictionary[] = {}

@onready var white_note_column: TextureRect = %WhiteNoteColumn
@onready var red_note_column: TextureRect = %RedNoteColumn
@onready var timer1: Timer = $Timer
@onready var timer2: Timer = $Timer2
const NOTE = preload("uid://dilpgmxld0ree")

func _ready():
	timer1.timeout.connect(generate)
	timer2.timeout.connect(generate_red)

	
func generate() -> void:
	var icon = NOTE.instantiate()
	white_note_column.add_child(icon)
	#print(typeof(icon))
	icon.position.x = icon.time * 300.0

func generate_red() -> void:
	var icon = NOTE.instantiate()
	red_note_column.add_child(icon)
	icon.position.x = icon.time * 300.0

func _process(delta: float) -> void:
	for note in white_note_column.get_children():
		note.time -= delta
		note.position.x = note.time * 300.0
		
	for note in red_note_column.get_children():
		note.time -= delta
		note.position.x = note.time * 300.0
	
	if white_note_column.get_child_count() != 0:
		miss_check(white_note_column.get_child(0))
	if red_note_column.get_child_count() != 0:
		miss_check(red_note_column.get_child(0))

func miss_check(note) -> void:
	if note == null:
		return
	if note.time < -0.55:
		note.queue_free()
		print("missed")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("white_node_press"):
		var current_note := white_note_column.get_child(0)
		if current_note == null:
			return
		if input_check(current_note):
			white_note_column.get_child(0).queue_free()
			
	elif event.is_action_pressed("red_node_press"):
		var current_note := red_note_column.get_child(0)
		if current_note == null:
			return
		if input_check(current_note):
			red_note_column.get_child(0).queue_free()
		

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
