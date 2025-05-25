extends Area2D

@onready var garagem = get_node("/root/Main/Garagem")
@onready var card = get_node("/root/Main/Area2D2/Card")  # <- Nodo que queremos ocultar

var player_can_trigger = false

func _ready():
	# Começa sem monitorar o jogador
	monitoring = false
	set_deferred("monitorable", false)

func _process(_delta):
	# Ativa a trigger se a garagem não estiver visível
	if not player_can_trigger and not garagem.visible:
		player_can_trigger = true
		monitoring = true
		set_deferred("monitorable", true)
		print("CardTrigger agora está ativo e pode detectar o jogador.")

func _on_body_entered(body):
	if player_can_trigger and body.name == "Player" and is_instance_valid(card):
		print("Player entrou na CardTrigger!")
		card.queue_free()
