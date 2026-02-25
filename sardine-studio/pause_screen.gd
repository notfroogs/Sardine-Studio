@tool
extends Control

@onready var _blur_color_rect: ColorRect = %BlurColorRect
@onready var _ui_panel_container: PanelContainer = %UIPanelContainer

@export_range(0, 1.0) var menu_opened_amount := 0.0:
	set = set_menu_opened_amount

func set_menu_opened_amount(amount: float) -> void:
	menu_opened_amount = amount
	visible = amount > 0
	if _ui_panel_container == null or _blur_color_rect == null:
		return
	_blur_color_rect.material.set_shader_parameter("blur_amount", lerp(0.0, 1.5, amount))
	_blur_color_rect.material.set_shader_parameter("saturation", lerp(1.0, 0.3, amount))
	_ui_panel_container.modulate.a = amount
