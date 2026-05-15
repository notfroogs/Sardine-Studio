extends Area2D

var is_dialogue_active = false
var player_entered = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_entered = false
	Gamemanager.dialogue_is_active = false
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if Gamemanager.number_of_days == 4 and player_entered == true:
		#Gamemanager.number_of_days == 5
		#Gamemanager.dialogue_is_active = true
		#is_dialogue_active = true
		#DialogueManager.show_dialogue_balloon(preload("res://dialouge/new_dialogue/third_round.dialogue"), "idk_what_this_is")
		pass
func _on_area_entered(area: Area2D) -> void:
	player_entered = true
	if Gamemanager.number_of_days == 4:
		Gamemanager.the_dog = true
		Gamemanager.number_of_days = 5


func _on_area_exited(area: Area2D) -> void:
	player_entered = false

func _on_dialogue_started(dialogue):
	is_dialogue_active = true
	Gamemanager.dialogue_is_active = false
	
func _on_dialogue_ended(dialogue):
	await get_tree().create_timer(0.2).timeout
	is_dialogue_active = false
	Gamemanager.dialogue_is_active = false
	print(Gamemanager.dialogue_is_active)
