extends RigidBody2D

#boss
var dir = -1
var last_dir = -1
var speed = 0
var lives = 3
var is_dead = false
var active = false
var n = 0

#dash
var is_dashing = false
var dash_timer = 0.0
var dash_force: float = 300.0
var dash_duration: float = 0.8

#fases
var walking_time = 0.0
var is_channeling = false
var idle = false

@onready var detect_left: RayCast2D = $Detect_left
@onready var detect_right: RayCast2D = $Detect_right
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var damage_hitbox = $Damage_hitbox
@onready var kill_hitbox = $Kill_hitbox
@onready var player = get_node("../Player")
@onready var cooldown_timer: Timer = $CooldownTimer


func _ready():
	print("Boss")

func activate_enemy():
	if not active and not is_dead:
		active = true
		speed = 0
		animation.play("idle")

func _physics_process(delta):
	if not active or is_dead or not idle:
		return
		
	if animation.animation != "sleep":
		if not is_channeling and not is_dashing:
			walking_time += delta
			handle_direction()
			handle_movement(delta)
			
			if walking_time >= 3.0:
				if player: 
					if player.global_position.x < global_position.x:
						dir = -1
						animation.flip_h = true
					else:
						dir = 1
						animation.flip_h = false
						
				is_channeling = true
				print("Channeling")
				animation.play("channeling")

		elif is_channeling:
			if animation.animation == "channeling" and animation.frame == animation.sprite_frames.get_frame_count("channeling") - 1:
				is_channeling = false
				start_dash()

		elif is_dashing:
			handle_dash(delta)

func _on_animated_sprite_2d_animation_finished():
	if animation.animation == "idle":
		idle = true
		animation.play("walking")
	elif animation.animation == "death":
		queue_free()
	elif animation.animation == "sleep":
		$Damage_hitbox.set_deferred("monitoring", true)
		$Kill_hitbox.set_deferred("monitoring", false)

func handle_direction():
	if detect_left.is_colliding():
		dir = 1
		animation.flip_h = false
	elif detect_right.is_colliding():
		dir = -1
		animation.flip_h = true

	if last_dir != dir:
		speed = 0
		last_dir = dir

func handle_movement(delta):
	speed += 7 * delta
	position.x += 3 * speed * delta * dir

func start_dash():
	is_dashing = true
	dash_timer = dash_duration

func handle_dash(delta):
	position.x += dash_force * delta * dir
	dash_timer -= delta
	if dash_timer <= 0.0:
		is_dashing = false
		walking_time = 0.0
		n += 1
		if n >= 3:
			n = 0
			animation.play("sleep")
		else: 
			animation.play("walking")

func _on_damage_hitbox_body_entered(body: Node2D) -> void:
	if is_dead:
		return

	if animation.animation == "sleep":
		if damage_hitbox.get_overlapping_bodies().has(body):
			lives -= 1
			print("Vidas: ", lives)
			
		if "velocity" in body:
			var direction = (body.global_position - global_position).normalized()
			body.velocity.y = -200
			body.velocity.x = direction.x * 1500


			if lives <= 0:
				is_dead = true
				animation.play("death")
				$Damage_hitbox.set_deferred("monitoring", false)
				$Kill_hitbox.set_deferred("monitoring", false)
			else:
				animation.play("walking")
				walking_time = 0.0
				is_channeling = false
				is_dashing = false
				idle = true
				$Kill_hitbox.set_deferred("monitoring", false)
				print("Cooldown iniciado...")
				cooldown_timer.start()     

func _on_cooldown_timer_timeout() -> void:
	$Kill_hitbox.set_deferred("monitoring", true)

func _on_kill_hitbox_body_entered(body: Node2D) -> void:
	if body == player:
		call_deferred("reload_scene")
		
func reload_scene():
	get_tree().reload_current_scene()
