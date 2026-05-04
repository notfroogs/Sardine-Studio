extends Area2D

@onready var label: Label = $Label
var is_player_close = false
var is_dialogue_active = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible = false
	Gamemanager.dialogue_is_active == false
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_player_close and Input.is_action_just_pressed("attack") and not is_dialogue_active:
		DialogueManager.show_dialogue_balloon(preload("res://dialouge/new_dialogue/Veronica.dialogue"),"intro")
		Gamemanager.dialogue_is_active = true
func adeline():
	pass


func _on_area_entered(area: Area2D) -> void:
	label.visible = true
	is_player_close = true


func _on_area_exited(area: Area2D) -> void:
	label.visible = false
	is_player_close = false
	
func _on_dialogue_started(dialogue):
	is_dialogue_active = true
	Gamemanager.dialogue_is_active = true
func _on_dialogue_ended(dialogue):
	await get_tree().create_timer(0.2).timeout
	is_dialogue_active = false
	Gamemanager.dialogue_is_active = false
