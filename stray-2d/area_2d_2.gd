extends Area2D

func _ready():
	$TileMap.visible = false  # Garante que começa invisível
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.name == "Player":
		$TileMap.visible = true
		print("Player entrou no item!")

func _on_body_exited(body):
	if body.name == "Player":
		$TileMap.visible = false
		print("Player saiu do item!")
