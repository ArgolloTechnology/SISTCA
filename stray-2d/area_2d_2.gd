extends Area2D

@onready var gar = get_node("/root/Main/Garagem")
@onready var card = get_node("/root/Main/Area2D2/Card")

func _ready():
	$Low.visible = false  # Garante que começa invisível
	$Low2.visible = true
	$High.visible = false  # Garante que começa invisível
	if is_instance_valid(card):
		$Card.visible = false
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if not gar.visible:
		if body.name == "Player":
			$Low.visible = true
			$Low2.visible = false
			$High.visible = true
			if is_instance_valid(card):
				$Card.visible = true
			print("Player entrou no item!")

func _on_body_exited(body):
	if not gar.visible:
		if body.name == "Player":
			$Low.visible = false
			$Low2.visible = true
			$High.visible = false
			if is_instance_valid(card):
				$Card.visible = false
			print("Player saiu do item!")
