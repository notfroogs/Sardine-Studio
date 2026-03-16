extends Control

@onready var enemyHp: ProgressBar = $enemyhpbar
@onready var playerHp: ProgressBar = $playerhpbar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemyHp.value = 100
	playerHp.value = 100



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemyhpbar_value_changed(value: float) -> void:
	if enemyHp.value <= 0.0:
		print("lose")
		get_tree().reload_current_scene()


func _on_playerhpbar_value_changed(value: float) -> void:
	if playerHp.value <= 0.0:
		print("lose")
		get_tree().reload_current_scene()
