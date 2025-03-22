extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $sitTimer
@onready var run_timer: Timer = $runTimer

const SPEED = 50
const JUMP_VELOCITY = -150.0
const RUN_MULTIPLIER = 2

var can_walk = false
var running = false
var jumping = false
var movement = "walk"
var idle = "idle"

func _process(_delta: float) -> void:
	movement = "run" if running else "walk"
	if velocity.y > 0 and anim.animation != "falling":
		anim.play("falling")

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()
	handle_movement()
	move_and_slide()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_jump() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not jumping:
		anim.play("jump")
		jumping = true
	if anim.frame == 2 and jumping and anim.animation != "falling":
		velocity.y = JUMP_VELOCITY
	if anim.animation == "falling" and is_on_floor():
		jumping = false

func handle_movement() -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction and can_walk:
		anim.flip_h = direction < 0
		if not jumping:
			anim.play(movement)
		idle = "idle stand"
		velocity.x = direction * SPEED * (RUN_MULTIPLIER if running else 1)
		#if is_on_floor():
		timer.start()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if not running:
			run_timer.start()
		if not jumping and velocity.y == 0:
			anim.play(idle)
	
	if direction and not can_walk:
		idle = "stand"

func _on_timer_timeout() -> void:
	idle = "sit"
	can_walk = false
	running = false
	anim.play(idle)

func _on_animated_sprite_2d_animation_finished() -> void:
	match idle:
		"sit":
			idle = "idle"
		"stand":
			can_walk = true
			print("pode andar")
	#if anim.animation == "falling":
	#	jumping = false
		#anim.set_frame_and_progress(4,0)
		

func _on_run_timer_timeout() -> void:
	running = true
