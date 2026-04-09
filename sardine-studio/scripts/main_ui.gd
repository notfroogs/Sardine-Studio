extends Control

@onready var enemyHp: ProgressBar = $enemyhpbar
@onready var playerHp: ProgressBar = $playerhpbar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemyHp.value = 100
	playerHp.value = 100



## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_enemyhpbar_value_changed(value: float) -> void:
	if enemyHp.value <= 0.0:
		print("win")
		restart()


func _on_playerhpbar_value_changed(value: float) -> void:
	if playerHp.value < 25.0:
		pass #icon change
	if playerHp.value <= 0.0:
		print("lose")
		restart()

func restart() -> void:
	if NavigationManager.previous_level != null:
		NavigationManager.go_to_level(NavigationManager.previous_level, null)
	else:
		#add a reults screen and restart or return buttons
		get_tree().reload_current_scene()
