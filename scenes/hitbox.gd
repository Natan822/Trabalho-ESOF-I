extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if Input.is_action_pressed("ui_accept"):
			body.velocity.y += body.JUMP_FORCE * 1.25
		else:
			body.velocity.y += body.JUMP_FORCE / 2
		owner.queue_free()
		
