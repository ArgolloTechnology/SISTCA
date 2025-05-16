extends Node2D

var dir = 1
var last_dir = 1
var speed = 100.0
var killed = 1
var stunned = false  # <-- novo: se bateu na parede, fica 'stunned'

@onready var timer: Timer = $Timer
@onready var detect_left: RayCast2D = $Detect_left
@onready var detect_right: RayCast2D = $Detect_right
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var player := $"../Player"

func _ready() -> void:
	animation.play("walking")
	print("Come fight me")
	timer.one_shot = true
	timer.wait_time = 5  # 5 segundos de stun
	timer.timeout.connect(_on_timer_timeout)

func _process(delta: float) -> void:
	if player == null:
		return
	
	if not stunned:
		var direction = player.global_position.x - global_position.x
		
		if abs(direction) > 5:  # margem pra não tremer quando colado
			dir = sign(direction)
			animation.flip_h = dir < 0
	
	# Movimento acontece sempre, mesmo no stun
	position.x += dir * speed * delta * killed
	
	# Checar colisão só se não estiver stun
	if not stunned:
		if detect_left.is_colliding():
			_handle_wall_collision(1)
		if detect_right.is_colliding():
			_handle_wall_collision(-1)
	
	# Aceleração
	if last_dir == dir:
		speed += 5 * delta
	else:
		speed = 0
		last_dir = dir

func _handle_wall_collision(new_dir: int) -> void:
	dir = new_dir
	stunned = true
	timer.start()
	animation.flip_h = dir < 0
	print("Bati na parede, andando na direção oposta por 5s")

func _on_timer_timeout() -> void:
	stunned = false
	print("Voltei a perseguir o player!")

func restartlevel():
	get_tree().reload_current_scene()

func _on_damage_hitbox_body_entered(_body: Node2D) -> void:
	print("Skill issue")
	call_deferred("restartlevel")

func _on_kill_hitbox_body_entered(_body: Node2D) -> void:
	killed = 0
	animation.play("death")
	get_node("Damage_hitbox/CollisionShape2D").free()

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
