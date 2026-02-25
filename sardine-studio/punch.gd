class_name PunchState
extends State

func enter() -> void:
	get_tree().animation
	
func exit() -> void:
	pass
	
func process_frame(delta:float) -> State:
	return null
func process_input(event: InputEvent) -> State:
	return null
func process_physics(delta:float) -> State:
	return null
