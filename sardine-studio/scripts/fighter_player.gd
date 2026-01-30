class_name Player extends CharacterBody2D


const SPEED = 1000.0
const JUMP_VELOCITY = -700.0
const GRAVITY = 1000.0
var increased_gravity = 20000

@onready var hitbox: CollisionShape2D = $hitBox/CollisionShape2D
@onready var hurtbox: CollisionShape2D = $hurtbox/CollisionShape2D


signal player_hit

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	#down faster
	if Input.is_action_just_pressed("crouch") and not is_on_floor():
		pass
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		print("hit")
		emit_signal("player_hit")
	hurtbox.set_deferred("disable", true)
	if hurtbox.disabled == true:
		print("noHitnox")
	

#func _on_area_2d_body_entered(body: Node2D) -> void:
	#pass # Replace with function body.
func take_dammage(amount:int) -> void:
	print("player dammage: ", amount)
