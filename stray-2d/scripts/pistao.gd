extends Node2D
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.wait_time = get_meta("delay")
	timer.start()

func _on_timer_timeout() -> void:
	$AnimationPlayer.play("idle")
