extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"
@onready var button: Button = $"../CanvasLayer/Button"

var interact: Callable = func():
	pass

#callable is a built in type representing method 4 object instance 
#standalone function which ??? interaction area should b able 2 override
#hmm..

#layer is TBA and mask is 2 to mach with player layer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("PLAYER") && button:
		button.show_for(self)

#area2d signals + called 4 visible button 

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("PLAYER") && button:
		button.hide_for(self)
