class_name playerO extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -500.0
@export var max_speed= 1050.0
@export var acceleration := 1000.0
@export var deacceleration := 1300.0
@export var fast_fall_speed := 2.0
@export var jump_floats:= 1.001
@onready var overworld_street: Node2D = $".."
@onready var overworld: Node2D = $".."
#@onready var spawn: Marker2D = $"../Garagedoor_A/spawn"
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

#var select
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
		#this is breaking my code for sime reason???? but only in garage
		var desired_velocity_x = direction_x * max_speed
		velocity.x = move_toward(velocity.x, desired_velocity_x, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, deacceleration * delta)
	move_and_slide()
	#flips sprite 
	if direction_x >0:
		sprite_2d.flip_h = false
	elif direction_x <0:
		sprite_2d.flip_h = true
	
#animation
	if is_on_floor():
		if direction_x == 0:
			sprite_2d.play("idle")
		else:
			sprite_2d.play("walk")
	else:
		sprite_2d.play("jump")
	
		
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("attack"):
		var scene_name = get_tree().current_scene.name
		
		#For every door in the group of "level select"
		for selection in get_tree().get_nodes_in_group("level_select"):
			
			#if the position of the player's character is +-70 near the selection node
			if abs(selection.global_position - global_position).x < 70:
				#save the current scene name so that it can return back the scene 
				#that it came from after the game is ended 
				NavigationManager.previous_level = scene_name
				
				match scene_name:
					"overworld":
						
						#the selection.name is its name in the scene tree
						match selection.name:
							"fighter":
								get_tree().change_scene_to_file("res://scenes/fighter_main.tscn")
							"playing":
								get_tree().change_scene_to_file("res://rhythm/rhythm_test.tscn")
					
					#expand scene_name's case further if needed
					
					
		#if select == "a":
				#print("a")
				#NavigationManager.previous_level = "overworld"
				#get_tree().change_scene_to_file("res://scenes/fighter_main.tscn")
		#if select == "b":
				#print('B')
				#if scene_name == "overworldStreet":
					#get_tree().change_scene_to_file("res://overworld/scene/overworld.tscn")
				#elif scene_name == "overworld":
					#NavigationManager.previous_level = "overworld"
					#get_tree().change_scene_to_file("res://rhythm/rhythm_test.tscn")
#
		#if select== "c":
			#if scene_name == "garage":
				#get_tree().change_scene_to_file("res://overworld/scene/overworld_street.tscn")   
			#if scene_name == "overworldStreet":
				#get_tree().change_scene_to_file("res://overworld/scene/garage.tscn")
			#

func _ready() -> void:
	NavigationManager.on_trigger_player_spawn.connect(_on_spawn)
	
#func _on_spawn(position: Vector2,direction:String):
func _on_spawn(position: Vector2):
	print("player is spawning at position: " + str(position))
	global_position = position
	
