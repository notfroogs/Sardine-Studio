class_name Enemy extends CharacterBody2D


const MAX_SPEED = 300.0
const JUMP_VELOCITY = -700.0


@onready var progress_bar: ProgressBar = $enemybar
@onready var hitbox: CollisionShape2D = $hitBox/CollisionShape2D
var in_hit_box
var player

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# =Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x : float = -1 if (global_position.x > player.global_position.x) else 1
	#var direction := global_position.direction_to(player.global_position)
	var distance_x : float = abs(global_position.x - player.global_position.x)
	distance_x -= 180
	
	var speed : float = MAX_SPEED if distance_x > 100 else MAX_SPEED * distance_x / 100
	velocity.x = (direction_x * speed)
	
	if is_on_floor() and (player.position.y - position.y < -50.0):
		velocity.y = JUMP_VELOCITY

	move_and_slide()
	

func _ready() -> void:
	progress_bar.value = 100
	if get_node("../fighterPlayer") != null:
		player = $"../fighterPlayer"
	
	
func take_dammage(amount:int) -> void:
	print("Enemy dammage: ", amount)
	progress_bar.value -= amount

#func _win() -> void:
	if progress_bar.value == 0.0:
		print("win")
		get_tree().reload_current_scene()
	

func _on_fighter_player_player_hit() -> void:
	if in_hit_box==false:
		print("nohitbox")
	elif in_hit_box == true: 
		take_dammage(10)



func _on_hit_box_area_entered(area: Area2D) -> void:
	in_hit_box = true

func _on_hit_box_area_exited(area: Area2D) -> void:
	in_hit_box = false
