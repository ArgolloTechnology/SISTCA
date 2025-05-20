extends Area2D

@onready var card = get_node("/root/Main/Area2D2/Card")
@onready var gate = get_node("/root/Main/Gate")

func _ready() -> void:
	pass#connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Player" and not is_instance_valid(card):
			print("Card está invisível, removendo Gate.")
			gate.queue_free()  # Ou gate.visible = false se quiser apenas ocultar
