extends Control

@onready var retry_button: Button = $"Lose/retry button"
@onready var return_button: Button = $"Lose/return button"
@onready var continue_button: Button = $"Win/continue button"
@onready var lose: Control = $Lose
@onready var win: Control = $Win
@onready var winsound: AudioStreamPlayer2D = $Win/winsound
@onready var losesound: AudioStreamPlayer2D = $Lose/losesound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Gamemanager.last_battle_won== true:
		win.set_deferred("visible",true)
		winsound.play()
		lose.set_deferred("visible",false)
	else:
		lose.set_deferred("visible",true)
		losesound.play()
		win.set_deferred("visible",false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_button_pressed() -> void:
	if NavigationManager.previous_level != null:
		NavigationManager.go_to_level(NavigationManager.previous_level, null)
	else:
		#add a reults screen and restart or return buttons
		get_tree().reload_current_scene()


func _on_return_button_pressed() -> void:
	if NavigationManager.previous_level != null:
		NavigationManager.go_to_level(NavigationManager.previous_level, null)
	else:
		#add a reults screen and restart or return buttons
		get_tree().reload_current_scene()


func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/fighter_main.tscn")
