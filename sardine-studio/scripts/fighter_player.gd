class_name Player extends CharacterBody2D


const SPEED = 1000.0
const JUMP_VELOCITY = -700.0
const GRAVITY = 1000.0
var increased_gravity = 20000
#var direction: Vector2 = Vector2.ZERO


@onready var hitbox: CollisionShape2D = $hitBox/CollisionShape2D2
@onready var hurtbox: CollisionShape2D = $hurtbox/CollisionShape2D
@onready var state_machine: Node2D = $StateMachine
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var hit_box:= $hitBox
@export var max_speed= 1050.0
@export var acceleration := 1300.0
@export var deacceleration := 1100.0
@export var fast_fall_speed := 2.0
@export var jump_floats:= 1.001
#@onready var collision_shape_2d: Facing = $hitBox/CollisionShape2D
var is_attacking = false

signal player_hit
signal player_direction_changes(facing_right: bool)
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
	var has_input_direction : bool = direction_x !=0
	if has_input_direction:
		var desired_velocity_x = direction_x * max_speed
		velocity.x = move_toward(velocity.x, desired_velocity_x, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, deacceleration * delta)
	move_and_slide()
	#if direction.length() > 0.0:
		#var current_speed_percent = velocity.length()/max_speed

	#if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		sprite.play("punch")
	if is_attacking:
		return #block other animation
	if direction_x > 0:
		sprite.flip_h = false
		hitbox.position = hitbox.facing_right_position
		#print("right")
	elif direction_x < 0:
		hitbox.position = hitbox.facing_left_position
		sprite.flip_h = true
		#print("left")
	if is_on_floor():
		if direction_x == 0:
			sprite.play("idle")
		else:
			sprite.play("walk")
		
	else:
		sprite.play("jump")
	emit_signal("player_direction_changes", !sprite.flip_h)
	update_player_sprites()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		sprite.play("punch")
		var areas_in_hit_box = hit_box.get_overlapping_areas()
		if  areas_in_hit_box != []:
			if get_parent().get_node("CanvasLayer/main ui/enemyhpbar") != null:
				get_parent().get_node("CanvasLayer/main ui/enemyhpbar").value -= 10
		hurtbox.set_deferred("disable", true)
	if hurtbox.disabled == true:
		print("noHitnox")
	

#func _on_area_2d_body_entered(body: Node2D) -> void:
	#pass # Replace with function body.

func ready():
	pass
#func _physics(delta): state_machine.process_frame(delta)

func update_player_sprites():
	pass
#	if direction.x > 0:
#		sprite.flip_h = false
#		emit_signal("player_direction_changes", sprite.flip_h)
#	elif direction.x < 0:
#		sprite.flip_h = true
		
