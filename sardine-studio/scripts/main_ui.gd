extends Control

@onready var enemyHp: ProgressBar = $enemyhpbar
@onready var playerHp: ProgressBar = $playerhpbar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemyHp.value = 100
	playerHp.value = 100
	if enemyHp.value == 0.0:
		print("win")
		get_tree().reload_current_scene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
