extends Label

func _process(delta: float) -> void:
	var vidas : int = get_parent().vidas
	if vidas >= 10:
		self.text = str(get_parent().vidas)
	else:
		self.text = '0' + str(get_parent().vidas)
