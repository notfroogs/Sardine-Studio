extends Control

@onready var sub_viewport: SubViewport = $SubViewport

func _ready() -> void:
	sub_viewport.size.x = 64
