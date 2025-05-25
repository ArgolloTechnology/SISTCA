extends Area2D

@onready var text_box = get_node_or_null("/root/Main/TextBox")  # Usa get_node_or_null para segurança

func _ready():
	if is_instance_valid(text_box):
		text_box.visible = false

func _on_body_entered(body):
	if body.name == "Player" and is_instance_valid(text_box):
		text_box.visible = true

func _on_body_exited(body):
	if body.name == "Player" and is_instance_valid(text_box):
		text_box.visible = false
