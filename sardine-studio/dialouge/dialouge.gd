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
@onready var scenetransition: Control = $scenetransition

var has_played_audio_2 = false

var faces : = {
	"FREESIA_NORMAL" = preload("res://Assets/faces/freesia normal.png"),
	"FREESIA_HAPPY" = preload("res://Assets/faces/freesia happy.png"),
	"FREESIA_MAD" = preload("res://Assets/faces/freesia mad.png"),
	"FREESIA_SHOCK" = preload("res://Assets/faces/freesia shock.png"),
	"FREESIA_YAY" = preload("res://Assets/faces/freesia yay.png"),
	"SHIVA_EH" = preload("res://Assets/faces/shiva eh.png"),
	"SHIVA_NORMAL" = preload("res://Assets/faces/shiva normal.png"),
	"MAN" = preload("res://Assets/faces/man.png"),
	"MAN_TALK" = preload("res://Assets/faces/man talk.png"),
	"SHIVA_BORED" = preload("res://Assets/faces/shiva bored.png"),
	"BLANK" = preload("res://Assets/faces/blank.png")
}
var backgrounds : = {
	"bg1" = preload("res://Assets/faces/bg1.png"),
	"bg2" = preload("res://Assets/faces/bg2.png"),
	
}

var dialouge_playing := 0
var dialogue_items: Array[Dictionary] = [
	{
		"text":"10 years ago, great evil has taken over the lands.",
		"name":"Narrator",
		"face":faces["BLANK"],
		"background":backgrounds["bg1"]
	},
	{
		"text":"With the silver mirror to purge darkness and the King's Blade to cut down shadows,",
		"name":"Narrator",
		"face":faces["BLANK"],
		"background":backgrounds["bg1"]
	},
	{
		"text":"The destined hero, Shiva and his companion, Freesia of the fae,",
		"name":"Narrator",
		"face":faces["BLANK"],
		"background":backgrounds["bg1"]
	},
	{
		"text":"Will the save the-",
		"name":"Narrator",
		"face":faces["BLANK"],
		"background":backgrounds["bg1"]
	},
	{
		"text":"I CAN'T BELIVE IT!",
		"name":"[center]Freesia[center]",
		"face":faces["FREESIA_SHOCK"],
		"background":backgrounds["bg1"]
		},
	{
		"text": "FIRST YOU LOSE THE KING'S BLADE,",
		"name": "[center]Freesia[center]",
		"face":faces["FREESIA_SHOCK"],
		"background":backgrounds["bg1"]
		},
	{
		"text": "THEN LOSE THE ALL THE PIECES OF THE SILVER MIRROR!",
		"name": "[center]Freesia[center]",
		"face":faces["FREESIA_MAD"],
		"background":backgrounds["bg1"]
		},
	{
		"text":"...",
		"name":"[center]Shiva[center]",
		"face":faces["SHIVA_EH"],
		"background":backgrounds["bg1"]
		},
	{
		"text":"I think the pieces fell down there...",
		"name":"[center]Shiva[center]",
		"face":faces["SHIVA_NORMAL"],
		"background": backgrounds["bg1"]
	},
	{
		"text":"Silver Mirror shards?",
		"name":"[center]Man[center]",
		"face":faces["MAN"],
		"background": backgrounds["bg2"]
		},
	{
		"text": "Yes! Have you seen them?",
		"name": "[center]Freesia[center]",
		"face":faces["FREESIA_YAY"],
		"background": backgrounds["bg2"]
		},
	{
		"text": "I might have saw them being scattered over there.",
		"name": "Man",
		"face":faces["MAN_TALK"],
		"background": backgrounds["bg2"]
		},
	{
		"text": "Thank you!",
		"name": "[center]Freesia[center]",
		"face": faces["FREESIA_HAPPY"],
		"background": backgrounds["bg2"]
		},
	{
		"text": "C'mon Shiva, lets go!",
		"name": "[center]Freesia[center]",
		"face":faces["FREESIA_YAY"],
		"background": backgrounds["bg2"]
		}
	
]

var current_item_index := 0
func _ready() -> void:
	show_text()
	nextbutton.pressed.connect(advance)
	#audio_2.stop()
		
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
		scenetransition.fade_out()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://Scene/game.tscn")
	else:
		show_text()
	if current_item_index > 3 and not has_played_audio_2:
		audio_2.play()	
		music.stop()
		has_played_audio_2 = true

#func _on_nextbutton_pressed() -> void:
	#select.play()

func _on_skip_pressed() -> void:
	scenetransition.fade_out()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scene/game.tscn")
