class_name Enemy extends CharacterBody2D

const MAX_SPEED = 300.0
const JUMP_VELOCITY = -700.0

enum State {
	FREE,
	ATTACKING,
	DIED,
	SPECIAL_ATTACK,
	SPECIAL_ATTACK_SUCC
}

@export var enemy_sprite = "red_hot_dog"

var current_state = State.FREE

@onready var hitbox_collision: CollisionShape2D = $hitBox/CollisionShape2D
@onready var hit_box: HitBoxA = $hitBox
@onready var hit_box_2: Area2D = $hitBox2


var enemy_dictionary = {
	"red_hot_dog": preload("uid://d15syuef80bmq"),
	"Mr_C": preload("uid://53yc3k3f67rs"),
	"Ms_E": preload("uid://bytifyaxxy3h8"),
	"Boss": preload("uid://b6d38eorkljg")
}

var player
var sprite_2d: AnimatedSprite2D
var attack_counting : float = 0

func _ready() -> void:
	enemy_sprite = Gamemanager.enemy
	
	sprite_2d = enemy_dictionary[enemy_sprite].instantiate()
	add_child(sprite_2d)
	sprite_2d.position = Vector2(-27, -167)
	match enemy_sprite:
		"Mr_C":
			attack_counting = 2
		"Boss":
			sprite_2d.position.y -= 30
	
	if get_node("../fighterPlayer") != null:
		player = $"../fighterPlayer"
	player.player_is_stun.connect(func(): change_state(State.SPECIAL_ATTACK_SUCC))
	
	sprite_2d.play("idle")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	match current_state:
		State.FREE:
			moving(delta)
		State.ATTACKING:
			velocity.x = 0
			move_and_slide()

func moving(delta):
	# =Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x : float = -1 if (global_position.x > player.global_position.x) else 1
	#sprite.flip_h = true if direction_x == -1 else false
	hitbox_collision.position.x = 190.0 * direction_x
	var distance_x : float = abs(global_position.x - player.global_position.x)
	distance_x -= 180
	
	var speed : float = MAX_SPEED if distance_x > 100 else MAX_SPEED * distance_x / 100
	
	velocity.x = (direction_x * speed)
	
	if is_on_floor() and (player.position.y - position.y < -50.0):
		velocity.y = JUMP_VELOCITY
	
	move_and_slide()
	
	match enemy_sprite:
		"red_hot_dog":
			count_hot_dog(delta)
		"Ms_E":
			count_E(delta)
		"Mr_C":
			count_C(delta, direction_x)
		"Boss":
			count_B(delta)

func count_hot_dog(delta):
	if abs(velocity.x) <= 200:
		attack_counting += delta
		if attack_counting >= 1.5:
			change_state(State.ATTACKING)
			attack_counting = 0.0

func count_E(delta):
	if abs(velocity.x) <= 200:
		attack_counting += delta
		if attack_counting >= 1.5:
			change_state(State.ATTACKING)
			attack_counting = 0.0

var special_attack_counting = 0

func count_C(delta, direction_x):
	if abs(velocity.x) <= 150:
		attack_counting += delta
		if attack_counting >= 2:
			change_state(State.ATTACKING)
			attack_counting = 0.0
			
	if abs(velocity.x) <= 50:
		special_attack_counting += delta
		if special_attack_counting >= 2.5:
			if player.current_state == 2:
				return
			velocity.x += direction_x * 2000
			move_and_slide()
			change_state(State.SPECIAL_ATTACK)
			special_attack_counting = 0

func count_B(delta):
	if abs(velocity.x) <= 200:
		attack_counting += delta
		if attack_counting >= 1.5:
			change_state(State.ATTACKING)
			attack_counting = 0.0


func pre_attack():
	sprite_2d.play("pre_punch")
	await sprite_2d.animation_finished
	if current_state == State.ATTACKING:
		attack()

func attack() -> void:
	var areas_in_hit_box = hit_box.get_overlapping_areas()
	if  areas_in_hit_box != []:
		
		if get_parent().get_node("CanvasLayer/main ui/playerhpbar") != null:
			match enemy_sprite:
				"Mr_C":
					player_is_hitted.emit(10)
				"red_hot_dog":
					player_is_hitted.emit(30)
				"Ms_E":
					player_is_hitted.emit(30)
				"Boss":
					player_is_hitted.emit(40)
			
	post_attack()

func post_attack() -> void:
	sprite_2d.play("post_punch")
	change_state(State.FREE)

func change_state(new_state):
	current_state = new_state
	match current_state:
		State.ATTACKING:
			pre_attack()
		State.FREE:
			sprite_2d.play("idle")
		State.DIED:
			pass
		State.SPECIAL_ATTACK:
			pre_Sattack()
		State.SPECIAL_ATTACK_SUCC:
			player_is_stun()

func pre_Sattack():
	sprite_2d.play("pre_Sattack")
	await sprite_2d.animation_finished
	if current_state == State.SPECIAL_ATTACK:
		Sattack1()

func Sattack1():
	var areas_in_hit_box = hit_box_2.get_overlapping_areas()
	if  areas_in_hit_box != []:
		
		if get_parent().get_node("CanvasLayer/main ui/playerhpbar") != null:
			player_is_hitted.emit(0)
	
	await get_tree().create_timer(0.5).timeout
	if current_state == State.SPECIAL_ATTACK:
		change_state(State.FREE)

func player_is_stun():
	sprite_2d.play("post_Sattack")
	await sprite_2d.animation_finished
	Sattack2()

func Sattack2():
	var areas_in_hit_box = hit_box.get_overlapping_areas()
	if  areas_in_hit_box != []:
		
		if get_parent().get_node("CanvasLayer/main ui/playerhpbar") != null:
			player_is_hitted.emit(35)
	change_state(State.FREE)

signal player_is_hitted

func die():
	change_state(State.DIED)
