extends Label

@onready var timer: Timer = $"../Timer"
var initial_time: int = 100

func _ready() -> void:
	self.text = str(initial_time)
	timer.start()

func _on_timer_timeout() -> void:
	initial_time -= 1
	self.text = str(initial_time)
