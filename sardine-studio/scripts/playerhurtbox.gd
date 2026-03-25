class_name HurtBoxB extends Area2D

func _init() -> void:
	#collision_layer = 0
	#collision_mask = 2
	pass

func _ready() -> void:
	area_entered.connect(self._on_area_entered)
	
func _on_area_entered(hitbox: HitBoxA) -> void:
	if hitbox == null:
		return
	if owner.has_signal("_on_fighter_player_player_hit"):
		owner.take_dammage(hitbox.dammage)
