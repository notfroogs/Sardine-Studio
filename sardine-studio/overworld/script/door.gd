class_name Door extends Area2D

@export var desitination_room: String
@export var destination_door: String


@onready var spawn: Marker2D = $spawn
 


func _on_body_entered(body: Node2D) -> void:
	if body is playerO:
		NavigationManager.go_to_level(destination_door,desitination_room)
