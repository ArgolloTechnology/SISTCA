extends Camera2D

var lastPos: float
var dir: float
var off: float
var target_offset: float  # Armazena o offset desejado

func _ready() -> void:
	lastPos = global_position.x
	off = offset.x
	target_offset = offset.x  # Inicializa com o offset atual

func _process(delta: float) -> void:
	dir = global_position.x - lastPos

	if dir > 0:
		target_offset = off
	elif dir < 0:
		target_offset = -off

	# Interpola suavemente o offset em direção ao alvo
	if offset.x != target_offset:
		offset.x = lerp(offset.x, target_offset, 2 * delta)  # Aumente o valor para uma transição mais rápida

	lastPos = global_position.x
