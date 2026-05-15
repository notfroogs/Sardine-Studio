extends Control

#@onready var _blur_color_rect: ColorRect = %BlurColorRect
#@onready var _ui_panel_container: PanelContainer = %UIPanelContainer
@onready var resume_button: Button = %ResumeButton
@onready var quit_button: Button = %QuitButton
@onready var help_button: Button = %HelpButton

#@export_range(0, 1.0) var menu_opened_amount := 0.0:
	#set = set_menu_opened_amount
#
#func set_menu_opened_amount(amount: float) -> void:
	#menu_opened_amount = amount
	#visible = amount > 0
	#if _ui_panel_container == null or _blur_color_rect == null:
		#return
	#_blur_color_rect.material.set_shader_parameter("blur_amount", lerp(0.0, 1.5, amount))
	#_blur_color_rect.material.set_shader_parameter("saturation", lerp(1.0, 0.3, amount))
	#_ui_panel_container.modulate.a = amount

func _ready() -> void:
	pass
	#print(resume_button)

func get_resume_button():
	return resume_button

func get_quit_button():
	return quit_button

func get_help_button():
	return help_button
