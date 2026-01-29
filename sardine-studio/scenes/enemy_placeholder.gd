extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var progress_bar: ProgressBar = $enemybar


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# =Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _ready() -> void:
	#_win()
	pass
func take_dammage(amount:int) -> void:
	pass
	print("Enemy dammage: ", amount)
	progress_bar.value -= amount

#func _win() -> void:
	if progress_bar.value == 0.0:
		print("win")
		get_tree().reload_current_scene()

func _on_fighter_player_player_hit() -> void:
	take_dammage(0)
