extends Area2D

@onready var text_box = get_node("/root/Main/TextBox2")
@onready var text_box2 = get_node("/root/Main/TextBox")
@onready var gar = get_node("/root/Main/Garagem")

var player_inside = false
var interagiu = false

func _ready():
	set_process_input(true)

func _on_body_entered(body):
	if body.name == "Player" and not interagiu:
		player_inside = true
		text_box.visible = true
		text_box2.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		player_inside = false

func _input(event):
	if player_inside and event.is_action_pressed("ui_focus_next") and not interagiu:
		if gar:
			gar.visible = false  # ou gar.queue_free()

		text_box.queue_free()   # ← Remove TextBox2 do jogo
		text_box2.queue_free()  # ← Remove TextBox do jogo
		interagiu = true
