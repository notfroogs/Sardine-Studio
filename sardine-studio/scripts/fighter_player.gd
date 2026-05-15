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
@onready var punchsound: AudioStreamPlayer2D = $punchsound
@onready var walk: AudioStreamPlayer2D = $walk
@onready var jump: AudioStreamPlayer2D = $jump

#@onready var collision_shape_2d: Facing = $hitBox/CollisionShape2D
var is_attacking = false

signal player_direction_changes(facing_right: bool)
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#print(sprite.animation)
	
	match current_state:
		State.ATTACKING:
			attack_momentum(delta)
			return
		State.HITSTUN:
			on_hitted_momentum(delta)
			return
		State.STUN:
			on_hitted_momentum(delta)
			return
		State.FREE:
			pass
		State.GUARD:
			return
	
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
			walk.stream_paused = true
			if current_state == State.FREE:
				sprite.play("idleV2")
		else:
			#FIX THE AUDIO NOT SUPPOSED TO PLAY ON COUNTDOWN
			walk.stream_paused = false
			sprite.play("walk")
	else:
		jump.play()
		sprite.play("jump")
	emit_signal("player_direction_changes", !sprite.flip_h)

func attack_momentum(delta):
	var direction_x := Input.get_axis("move_left", "move_right")
	var has_input_direction : bool = direction_x !=0
	if has_input_direction:
		velocity.x = move_toward(velocity.x, 0.0, deacceleration * 0.4 * delta)
	else:
		velocity.x = 0
	move_and_slide()

@warning_ignore("unused_parameter")
func on_hitted_momentum(delta):
	velocity.x = move_toward(velocity.x, 0.0, deacceleration * 0.4 * delta)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		match current_state:
			State.FREE:
				change_state(State.ATTACKING)
			State.GUARD_SUCC:
				change_state(State.ATTACKING)
	elif event.is_action_pressed("guard"):
		match current_state:
			State.FREE:
				change_state(State.GUARD)
				await sprite.animation_finished
				if current_state == State.GUARD:
					change_state(State.FREE)
	return

func pre_attack():
	sprite.play("pre_punch")
	await sprite.animation_finished
	if current_state == State.ATTACKING:
		attack()

func attack():
	var areas_in_hit_box = hit_box.get_overlapping_areas()
	if areas_in_hit_box != []:
		if get_parent().get_node("CanvasLayer/main ui/enemyhpbar") != null:
			get_parent().get_node("CanvasLayer/main ui/enemyhpbar").value -= 10
	punchsound.play()
	post_attack()

func post_attack():
	sprite.play("post_punch")
	await sprite.animation_finished
	if current_state == State.ATTACKING:
		change_state(State.FREE)

var enemy_placeholder : Enemy 

func _ready():
	walk.stream_paused = true
	#FIX THE AUDIO NOT SUPPOSED TO PLAY
	if walk.stream_paused == true:
		print("no walk")
	
	if get_tree() != null:
		enemy_placeholder = %enemy_placeholder
		enemy_placeholder.player_is_hitted.connect(is_hitted)
	
	#sprite.animation_finished.connect(test)
	
func test():
	pass
	#print("animation finished")

var previous_state = State.FREE
var current_state = State.FREE
enum State {
	FREE,
	ATTACKING,
	HITSTUN,
	GUARD,
	GUARD_SUCC,
	STUN
}

func change_state(new_state):
	sprite.speed_scale = 1
	previous_state = current_state
	current_state = new_state
	var direction = 1 if enemy_placeholder.global_position < global_position else -1
	
	match previous_state:
		State.HITSTUN:
			sprite.self_modulate.a = 1
		State.STUN:
			sprite.self_modulate.a = 1
			if new_state == State.HITSTUN:
				velocity.x += direction * 1000
		State.GUARD_SUCC:
			#print("Is new_state attack:", new_state == State.ATTACKING)
			if new_state == State.ATTACKING:
				sprite.speed_scale = 1.5
		
	match current_state:
		State.ATTACKING:
			velocity.x *= 0.5
			pre_attack()
		State.FREE:
			sprite.play("idleV2")
		State.HITSTUN:
			
			velocity.x *= 0.5
			velocity.x += direction * 100
			on_hitted()
		State.STUN:
			velocity.x = 0
			velocity.x += direction * 10
			on_hitted()
		State.GUARD:
			velocity.x = 0
			sprite.play("guard")
		State.GUARD_SUCC:
			sprite.play("gaurded")

signal player_is_damaged
signal player_is_stun

func is_hitted(amount):
	match current_state:
		State.HITSTUN:
			return
		State.GUARD:
			if guarding():
				guard_succ(amount)
				return
	if amount == 0:
		player_is_damaged.emit(1)
		change_state(State.STUN)
		player_is_stun.emit()
	else:
		player_is_damaged.emit(amount)
		change_state(State.HITSTUN)

func on_hitted():
	sprite.play("hitted")
	await get_tree().create_timer(1.0).timeout
	change_state(State.FREE)

var sine_value_t = 0.0

func _process(delta: float) -> void:
	#print(current_state)
	sine_value_t += delta
	match current_state:
		State.HITSTUN:
			sprite.self_modulate.a = (pow(sin(sine_value_t * 3 * PI), 2))
		State.STUN:
			sprite.self_modulate.a = 0.5 * (pow(sin(sine_value_t * PI), 2)) +0.5
	
func guarding():
	if sprite.frame == 2:
		return true
	else:
		return false

signal player_guard_succ

func guard_succ(amount):
	change_state(State.GUARD_SUCC)
	player_guard_succ.emit(amount)
	await get_tree().create_timer(0.3).timeout
	if current_state == State.GUARD_SUCC:
		change_state(State.FREE)
