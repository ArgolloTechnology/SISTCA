extends Node2D
@onready var timer: Timer = $Timer
var piston_left
var isDoor = false
var openTrigger : NodePath
var closeTrigger : NodePath
var open = false
var close = false
func _ready() -> void:
	openTrigger = get_meta("OpenTrigger")
	closeTrigger = get_meta("CloseTrigger")
	
	if get_meta("delay") > 0:
		timer.wait_time = get_meta("delay")
	if openTrigger or closeTrigger:
		isDoor = true
		print("door")
	if not isDoor:
		timer.start()
	if isDoor:
		$Killzone/CollisionShape2D.disabled = true
		if openTrigger:
			var openNode = get_node(openTrigger)
			if openNode is Area2D:
				openNode.connect("body_entered", Callable(self, "Open"))
			close = true
		if closeTrigger:
			var closeNode = get_node(closeTrigger)
			if closeNode is Area2D:
				closeNode.connect("body_entered", Callable(self, "Close"))
			open = true
		
func Open(body : Node2D):
	if body.name == "Player":
		if close:
			$AnimationPlayer.play_backwards("close")
			close = false
			print("abrir")
func Close(body):
	if body.name == "Player":
		if open:
			$AnimationPlayer.play("close")
			open = false
			print("fechar")
func  _process(delta: float) -> void:
	if isDoor:
		if get_node_or_null(openTrigger) == null and close:
			$AnimationPlayer.play_backwards("close")
			close = false
		if get_node_or_null(closeTrigger) == null and open:
			$AnimationPlayer.play("close")
			open = false

func _on_timer_timeout() -> void:
	$AnimationPlayer.play("idle")
