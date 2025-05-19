extends Node2D
@onready var timer: Timer = $Timer
var piston_left
var isDoor = false
func _ready() -> void:
	#piston_left = get_meta("piston_left")
	#print(piston_left)
	#if get_node_or_null(piston_left):
	#	isDoor = true
	timer.wait_time = get_meta("delay")
	if not isDoor:
		timer.start()
		
func  _process(delta: float) -> void:
	if isDoor:
		#if get_node_or_null(piston_left) == null:
			print("open")
			$AnimationPlayer.play("idle")

func _on_timer_timeout() -> void:
	$AnimationPlayer.play("idle")
