class_name Enemy extends CharacterBody2D


const MAX_SPEED = 300.0
const JUMP_VELOCITY = -700.0

enum State {
	FREE,
	ATTACKING
}
var current_state = State.FREE

@onready var sprite : Sprite2D = $Sprite2D
@onready var hitbox_collision: CollisionShape2D = $hitBox/CollisionShape2D
var in_hit_box
var player
var hit
@onready var hit_box: HitBoxA = $hitBox

@onready var animation_player: AnimationPlayer = %AnimationPlayer

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

func attack():
	change_state(State.ATTACKING)

func change_state(new_state):
	current_state = new_state
	if current_state == State.ATTACKING:
		animation_player.play("attack")

func _ready() -> void:
	if get_node("../fighterPlayer") != null:
		player = $"../fighterPlayer"
	
	
func take_dammage(amount:int) -> void:
	if hit == true:
		print("Enemy dammage: ", amount)
		get_parent().get_node("CanvasLayer/main ui/enemyhpbar").value -= amount
	if hit == false:
		return
#func _win() -> void:
	if get_parent().get_node("CanvasLayer/main ui/enemyhpbar").value == 0.0:
		print("win")
		get_tree().reload_current_scene()
	
func _input(event: InputEvent) -> void:
	if event.is_action("crouch"):
		attack()
		#var areas = hit_box.get_overlapping_areas()
		#for area in areas:
			#print(area.get_classname())
			#if area.is_class("HurtBoxB"):
				#print("yes")
				##$"../main ui"

func _on_fighter_player_player_hit() -> void:
	hit = true
	if in_hit_box==false:
		print("nohitbox")
	elif in_hit_box == true: 
		take_dammage(10)




func _on_hurtbox_area_entered(area: HitBoxB) -> void:
	in_hit_box = true

func _on_hurtbox_area_exited(area: HitBoxB) -> void:
	in_hit_box = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		var areas_in_hit_box = hit_box.get_overlapping_areas()
		if  areas_in_hit_box != []:
			
			if get_parent().get_node("CanvasLayer/main ui/playerhpbar") != null:
				get_parent().get_node("CanvasLayer/main ui/playerhpbar").value -= 10
			
		animation_player.play("attack_reset")
		change_state(State.FREE)
