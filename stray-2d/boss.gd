extends Node2D

var dir = 1
var last_dir = 1
var speed = 0
var lives = 3
var is_dead = false
var active = false  # Fica inativo até ser ativado

@onready var detect_left: RayCast2D = $Detect_left
@onready var detect_right: RayCast2D = $Detect_right
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var damage_hitbox = $Damage_hitbox
@onready var kill_hitbox = $Kill_hitbox

func _ready() -> void:
	animation.play("idle")
	print("Boss à espera de ser ativado...")

func _process(delta: float) -> void:
	if not active or is_dead:
		return

	if detect_left.is_colliding():
		dir = 1
		animation.flip_h = false
	elif detect_right.is_colliding():
		dir = -1
		animation.flip_h = true

	if last_dir == dir:
		speed += 5 * delta
	else:
		speed = 0
		last_dir = dir

	position.x += 3 * speed * delta * dir

func restartlevel():
	get_tree().reload_current_scene()

func _on_damage_hitbox_body_entered(body: Node2D) -> void:
	if is_dead:
		return

	# Garante que não foi o salto que causou esta colisão
	if not kill_hitbox.get_overlapping_bodies().has(body):
		print("Skill issue (morreu por contacto lateral)")
		call_deferred("restartlevel")

func _on_kill_hitbox_body_entered(body: Node2D) -> void:
	if is_dead:
		return

	lives -= 1
	print("Boss atingido! Vidas restantes: ", lives)

	if lives <= 0:
		is_dead = true
		animation.play("death")

		# Desativa o hitbox de dano para evitar que o jogador morra
		damage_hitbox.set_deferred("monitoring", false)

		# Remove o colisor da parte de cima
		$Damage_hitbox/CollisionShape2D.set_deferred("disabled", true)
		$Kill_hitbox/CollisionShape2D.set_deferred("disabled", true)

func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "death":
		queue_free()

func activate_enemy():
	if not active and not is_dead:
		active = true
		speed = 0
		animation.play("walking")
		print("Boss ativado!")
