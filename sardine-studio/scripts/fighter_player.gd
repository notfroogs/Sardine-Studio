class_name Player extends CharacterBody2D


const SPEED = 1000.0
const JUMP_VELOCITY = -700.0
const GRAVITY = 1000.0
var increased_gravity = 20000
#var direction: Vector2 = Vector2.ZERO

@onready var hitbox: CollisionShape2D = $hitBox/CollisionShape2D
@onready var hurtbox: CollisionShape2D = $hurtbox/CollisionShape2D
@onready var state_machine: Node2D = $StateMachine
@onready var sprite: Sprite2D = $Sprite2D
@export var max_speed= 1000.0
@export var acceleration := 1000.0
@export var deacceleration := 100.0




signal player_hit
signal player_direction_changes(facing_right: bool)
func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	#down faster
	if Input.is_action_just_pressed("crouch") and is_on_floor():
		print("down")
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#Player wornt deaccelrate fast enouggh fix this.
	var direction := Input.get_vector("move_left", "move_right", "jump","crouch")
	var has_input_direction := direction.length() > 0.0
	if has_input_direction:
		var desired_velocity = direction * max_speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deacceleration * delta)
	move_and_slide()
	if direction.length() > 0.0:
		var current_speed_percent = velocity.length()/max_speed

	#if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	
	update_player_sprites()
#func _ready() -> void:
	#pass

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
func ready(): state_machine.init()
func _physics(delta): state_machine.process_frame(delta)

func update_player_sprites():
	pass
#	if direction.x > 0:
#		sprite.flip_h = false
#		emit_signal("player_direction_changes", sprite.flip_h)
#	elif direction.x < 0:
#		sprite.flip_h = true
		
