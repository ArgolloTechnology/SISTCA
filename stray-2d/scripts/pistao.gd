extends Node2D
@onready var timer: Timer = $Timer
var enemy
var isDoor = false
func _ready() -> void:
	enemy = get_meta("enemy")
	if get_node_or_null(enemy):
		isDoor = true
	timer.wait_time = get_meta("delay")
	if not isDoor:
		timer.start()
		
func  _process(delta: float) -> void:
	if isDoor:
		if get_node_or_null(enemy) == null:
			print("open")
			$AnimationPlayer.play("idle")

func _on_timer_timeout() -> void:
	$AnimationPlayer.play("idle")
