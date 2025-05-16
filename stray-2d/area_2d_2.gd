extends Area2D

func _ready():
	$Low.visible = false  # Garante que começa invisível
	$High.visible = false  # Garante que começa invisível
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.name == "Player":
		$Low.visible = true
		$High.visible = true
		print("Player entrou no item!")

func _on_body_exited(body):
	if body.name == "Player":
		$Low.visible = false
		$High.visible = false
		print("Player saiu do item!")
