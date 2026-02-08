class_name Enemy extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


@onready var progress_bar: ProgressBar = $enemybar
@onready var hitbox: CollisionShape2D = $hitBox/CollisionShape2D

var in_hit_box
var hit
var knockback := Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# =Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	

func _ready() -> void:
	progress_bar.value = 100
	#_win()
	pass
func take_dammage(amount:int) -> void:
	if hit == true:
		print("Enemy dammage: ", amount)
		#make this part work in the ui
		get_parent().get_node("CanvasLayer/main ui/enemyhpbar").value -= amount
	if hit == false:
		return

#func _win() -> void:
#make this work in the ui
	if get_parent().get_node("CanvasLayer/main ui/enemyhpbar").value == 0.0:
		print("win")
		get_tree().reload_current_scene()
	

func _on_fighter_player_player_hit() -> void:
	hit = true
	if in_hit_box == false:
		print("nohitbox")
	elif in_hit_box == true: 
		take_dammage(10)
		velocity.y = JUMP_VELOCITY
		#var knockback_force = 300
		#velocity.x = sign(scale.x) * knockback_force



#func _on_hit_box_area_entered(_area: HurtBoxB) -> void:
	#print("entered")
	#in_hit_box = true

#func _on_hit_box_area_exited(_area: HurtBoxB) -> void:
	#print("exited")
	#in_hit_box = false


func _on_hurtbox_area_entered(area: HitBoxB) -> void:
	print("entered")
	in_hit_box = true


func _on_hurtbox_area_exited(area: HitBoxB) -> void:
	print("exited")
	in_hit_box = false
