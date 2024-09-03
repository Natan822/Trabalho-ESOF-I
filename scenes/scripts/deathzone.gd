extends CollisionShape2D



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.vidas = 1
		body.take_damage()
