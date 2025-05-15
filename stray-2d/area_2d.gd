extends Area2D

@export var zoom_out: Vector2 = Vector2(2, 2)
@export var zoom_time: float = 0.5

func _on_area_2d_body_entered(body: Node) -> void:
	if body.has_node("Camera2D"):
		var camera = body.get_node("Camera2D") as Camera2D

		# Animação de zoom usando Tween (opcional, visualmente mais suave)
		var tween := create_tween()
		tween.tween_property(camera, "zoom", zoom_out, zoom_time)


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
