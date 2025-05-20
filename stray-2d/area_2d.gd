extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.name == "Player":
		$Low.visible = false
		$High.visible = false
		print("Player entrou no item!")

func _on_body_exited(body):
	if body.name == "Player":
		$Low.visible = true
		$High.visible = true
		print("Player saiu do item!")
