extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -500.0
@export var max_speed= 1050.0
@export var acceleration := 1000.0
@export var deacceleration := 1300.0
@export var fast_fall_speed := 2.0
@export var jump_floats:= 1.001
@onready var overworld_street: Node2D = $".."

var select
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY* jump_floats
	#down faster
	if Input.is_action_pressed("crouch") and velocity.y > 0.0:
		velocity.y += get_gravity().y * fast_fall_speed * delta
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#Player wornt deaccelrate fast enouggh fix this.
	var direction_x := Input.get_axis("move_left", "move_right")
	var has_input_direction := direction_x !=0
	if has_input_direction:
		var desired_velocity_x = direction_x * max_speed
		velocity.x = move_toward(velocity.x, desired_velocity_x, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, deacceleration * delta)
	move_and_slide()
		
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("attack"):
			if select == "a":
				print("a")
				get_tree().change_scene_to_file("res://scenes/fighter_main.tscn")
			if select == "b":
				print('B')
				if get_parent() == overworld_street:
					get_tree().change_scene_to_file("res://overworld/scene/overworld.tscn")
	
func _on_fighter_body_entered(_body: Node2D) -> void:
	select = "a"


func _on_door_body_entered(body: Node2D) -> void:
	select = "b"
	
	
