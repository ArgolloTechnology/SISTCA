extends Area2D

@export var zoom_out: Vector2 = Vector2(2, 2)
@export var zoom_time: float = 0.5

@export var boss_path: NodePath 
@onready var boss = get_node_or_null(boss_path)

func _on_area_2d_body_entered(body: Node) -> void:
	if body.has_node("Camera2D"):
		var camera = body.get_node("Camera2D") as Camera2D

		var tween := create_tween()
		tween.tween_property(camera, "zoom", zoom_out, zoom_time)
		
	if body.name == "Player":
		if boss:
			boss.activate_enemy()
		else:
			print("Erro!")
