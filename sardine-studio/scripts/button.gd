extends Button


var current_interaction: Node = null

func _ready():
	visible = false
	disabled = true
	pressed.connect(_on_pressed)

func show_for(area: Node):
	current_interaction = area
	visible = true
	disabled = false
	global_position = area.global_position + Vector2(0, -50)
	
	#which area we r interacting w

func hide_for(area: Node):
	if current_interaction == area:
		current_interaction = null
		visible = false
		disabled = true

func _on_pressed():
	if current_interaction and current_interaction.has_variable("interact"):
		current_interaction.interact.call()
		
		#edit this to change scene later
