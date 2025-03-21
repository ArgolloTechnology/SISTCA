extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $sitTimer
@onready var run_timer: Timer = $runTimer

const SPEED = 50
const JUMP_VELOCITY = -400.0
const RUN_MULTIPLIER = 2

var can_walk = false
var running = false
var movement = "walk"
var idle = "idle"

func _process(_delta: float) -> void:
	movement = "run" if running else "walk"

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()
	handle_movement()
	move_and_slide()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_jump() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func handle_movement() -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction and can_walk:
		anim.flip_h = direction < 0
		anim.play(movement)
		idle = "idle stand"
		velocity.x = direction * SPEED * (RUN_MULTIPLIER if running else 1)
		timer.start()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if not running:
			run_timer.start()
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

func _on_run_timer_timeout() -> void:
	running = true
