extends Control

@onready var enemyHp: ProgressBar = $enemyhpbar
@onready var playerHp: ProgressBar = $playerhpbar
var results = preload("res://scenes/results_screen.tscn")
# Called when the node enters the scene tree for the first time.

@onready var enemy_placeholder: Enemy = %enemy_placeholder
@onready var fighter_player: Player = %fighterPlayer

func _ready() -> void:
	enemyHp.value = 100
	playerHp.value = 100
	fighter_player.player_is_damaged.connect(player_is_hitted)
	fighter_player.player_guard_succ.connect(player_guard_succ)

func player_is_hitted():
	playerHp.value -= 30

func player_guard_succ():
	playerHp.value -= 5

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

var in_game = true
signal game_ended

func _on_enemyhpbar_value_changed(value: float) -> void:
	if enemyHp.value <= 0.0 and in_game:
		in_game = false
		game_ended.emit()
		Gamemanager.last_battle_won = true
		restart()


func _on_playerhpbar_value_changed(value: float) -> void:
	#if playerHp.value < 25.0:
		#icon change
	
	if playerHp.value <= 0.0 and in_game:
		in_game = false
		game_ended.emit()
		Gamemanager.last_battle_won = false
		restart()

func restart() -> void:
	#if NavigationManager.previous_level != null:
		#NavigationManager.go_to_level(NavigationManager.previous_level, null)
	#else:
		#add a reults screen and restart or return buttons
		#get_tree().reload_current_scene()
	await get_tree().create_timer(1.0).timeout
	
	get_tree().change_scene_to_file("res://scenes/results_screen.tscn")
