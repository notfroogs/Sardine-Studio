extends Control


@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var nextbutton: Button = %nextbutton
@onready var control: Control = $"."
@onready var title: RichTextLabel = $title
@onready var icon: TextureRect = %icon
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var bg: TextureRect = $bg
@onready var select: AudioStreamPlayer2D = $select
@onready var music: AudioStreamPlayer2D = $music
@onready var audio_2: AudioStreamPlayer2D = $audio2
#@onready var scenetransition: Control = $scenetransition

var has_played_audio_2 = false

@export var faces : = {
	"ADELINEFIDGET" = preload("res://assets/dialouge sprites/Adaline Fidget.png"),
	"ADELINEHAPPY" = preload("res://assets/dialouge sprites/Adeline happy.png"),
	"ADELINEHURT" = preload("res://assets/dialouge sprites/Adeline Hurt.png"),
	"ADELINEMAD" = preload("res://assets/dialouge sprites/Adeline Mad.png"),
	"ADELINENEUTRAL" = preload("res://assets/dialouge sprites/Adeline Neutral.png"),
	"LYREAWKWARD" = preload("res://assets/dialouge sprites/Lyre Awkward.png"),
	"LYRECONCERNED" = preload("res://assets/dialouge sprites/Lyre Conserned.png"),
	"LYREEXCITED" = preload("res://assets/dialouge sprites/Lyre Excited.png"),
	"LYREHURT" = preload("res://assets/dialouge sprites/Lyre Hurt.png"),
	"LYRENEUTRAL" = preload("res://assets/dialouge sprites/Lyre Neutral.png"),
	"LYRESTARE" = preload("res://assets/dialouge sprites/Lyre Stare.png"),
	"SAMANNOYED" = preload("res://assets/dialouge sprites/Sam Annoyed.png"),
	"SAMAWKWARD" = preload("res://assets/dialouge sprites/Sam Awkward.png"),
	"SAMHAPPY" = preload("res://assets/dialouge sprites/Sam Happy.png"),
	"SAMMAD" = preload("res://assets/dialouge sprites/Sam Mad.png"),
	"SAMNEUTRAL" = preload("res://assets/dialouge sprites/Sam Neutral.png"),
	"SAMTHINKING" = preload("res://assets/dialouge sprites/Sam Thinking.png"),
	"VERONICANEUTRAL" = preload("res://assets/dialouge sprites/Veronica  Neutral.png"),
	"VERONICAANGRY" = preload("res://assets/dialouge sprites/Veronica Angry.png"),
	"VERONICAAWKWARD" = preload("res://assets/dialouge sprites/Veronica awkward .png"),
	"VERONICAHAPPY" = preload("res://assets/dialouge sprites/Veronica Happy.png"),
	"VERONICASPARKLE" = preload("res://assets/dialouge sprites/Veronica Sparkle.png"),
	"VERONICAWORRIED" = preload("res://assets/dialouge sprites/Veronica Worried.png")
}
@export var backgrounds : = {
	"bg1" = preload("res://assets/bg1.png"),
	"bg2" = preload("res://assets/bg2.png"),
}

var dialouge_playing := 0
var dialogue_items: Array[Dictionary] = [
	{
		"text":"This is placehodler dialouge",
		"name":"Lyre",
		"face":faces["LYRENEUTRAL"],
		"background":backgrounds["bg1"]
	},
	{
		"text":"Dialouge assets are being worked on",
		"name":"Lyre",
		"face":faces["LYREEXCITED"],
		"background":backgrounds["bg1"]
	},
	{
		"text":"blablabla",
		"name":"Lyre",
		"face":faces["LYREAWKWARD"],
		"background":backgrounds["bg1"]
	},
	{"text":"Wow the audio is really loud",
		"name":"Lyre",
		"face":faces["LYREHURT"],
		"background":backgrounds["bg1"]},
	{
		"text":"im going to fix that later",
		"name":"Lyre",
		"face":faces["LYRENEUTRAL"],
		"background":backgrounds["bg1"]
	}
		
	
]

var current_item_index := 0
func _ready() -> void:
	show_text()
	nextbutton.pressed.connect(advance)
	
		
func show_text() -> void:
	var current_item := dialogue_items[current_item_index]
	rich_text_label.text = current_item["text"]
	title.text = current_item["name"]
	icon.texture = current_item["face"]
	bg.texture = current_item["background"]
	
	rich_text_label.visible_ratio = 0.0
	var tween := create_tween()
	var text_appearing_duration: float = current_item["text"].length()/ 30.0
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)
	var sound_max_length := audio_stream_player_2d.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_length
	audio_stream_player_2d.play(sound_start_position)
	tween.finished.connect(audio_stream_player_2d.stop)
	
	nextbutton.disabled = true
	tween.finished.connect(func() -> void:
		nextbutton.disabled = false
		)
	
func advance() -> void:
	current_item_index += 1
	if current_item_index == dialogue_items.size():
		#scenetransition.fade_out()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/fighter_main.tscn")
		print("test")
	else:
		show_text()
	if current_item_index > 3 and not has_played_audio_2:
		audio_2.play()	
		music.stop()
		has_played_audio_2 = true

func _on_nextbutton_pressed() -> void:
	select.play()

func _on_skip_pressed() -> void:
	#scenetransition.fade_out()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/fighter_main.tscn")
