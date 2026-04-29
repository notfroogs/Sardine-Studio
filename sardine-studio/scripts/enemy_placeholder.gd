class_name Enemy extends CharacterBody2D


const MAX_SPEED = 300.0
const JUMP_VELOCITY = -700.0

enum State {
	FREE,
	ATTACKING,
	DIED
}
var current_state = State.FREE

@onready var hitbox_collision: CollisionShape2D = $hitBox/CollisionShape2D
@onready var hit_box: HitBoxA = $hitBox
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
#@onready var animation_player: AnimationPlayer = %AnimationPlayer

var player
func _ready() -> void:
	sprite_2d.play("idle")
	if get_node("../fighterPlayer") != null:
		player = $"../fighterPlayer"

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	match current_state:
		State.FREE:
			moving(delta)
		State.ATTACKING:
			velocity.x = 0
			move_and_slide()

var attack_counting : float = 0

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
			#get_parent().get_node("CanvasLayer/main ui/playerhpbar").value -= 30
			player_is_hitted.emit()
			
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

signal player_is_hitted

func die():
	change_state(State.DIED)
