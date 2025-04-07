extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $sitTimer
@onready var run_timer: Timer = $runTimer
@onready var moveParticle: GPUParticles2D = $GPUParticles2D
@onready var jump: GPUParticles2D = $jump
@onready var scratch: GPUParticles2D = $scratch
@onready var rest_time: Timer = $restTime

const SPEED = 50
const JUMP_VELOCITY = -300.0
const RUN_MULTIPLIER = 2

var can_walk = false
var running = false
var jumping = false
var movement = "walk"
var idle = "idle"
var scratching = false

func _process(_delta: float) -> void:
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
		moveParticle.emitting = false

func handle_jump() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not jumping:
		anim.play("jump")
		jumping = true
		jump.restart()
		jump.emitting = true
		scratch.emitting = false
	if anim.frame == 1 and jumping and anim.animation != "falling":
		velocity.y = JUMP_VELOCITY
		anim.frame = 2
		
	if anim.animation == "falling" and is_on_floor():
		jumping = false
	if anim.animation == "jump" and anim.frame > 2 and is_on_floor():
		jumping = false

func handle_movement() -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and can_walk:
		if is_on_wall():
			if not scratching and is_on_floor():
				movement = "wall sup"
				scratching = true
				moveParticle.emitting = false
				#mudar posição de scratch dependendo da direção
				scratch.position.x = abs(scratch.position.x) * direction
				scratch.rotation_degrees = 15 if direction > 0 else -15
		else:
			if running:
				movement = "run"  
				moveParticle.amount = 16
			else: 
				movement = "walk"
				moveParticle.amount = 4
			scratching = false
			scratch.emitting = false
		anim.flip_h = direction < 0
		if not jumping and is_on_floor():
			if not scratching:
				moveParticle.emitting = true
			anim.play(movement)
		
		if not running:
			idle = "idle stand"
		else: 
			idle = "idle stand run"
		velocity.x = direction * SPEED * (RUN_MULTIPLIER if running else 1)
		#if is_on_floor():
		timer.start()
	else:
		if movement == "wall scratch":
			movement = "wall out"
			can_walk = false
			anim.play(movement)
		#scratching = false
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if not running:
			run_timer.start()
			if anim.animation == "idle run" and anim.frame == 0:
				idle = "idle"
		if not jumping and velocity.y == 0 and not scratching:
			moveParticle.emitting = false
			anim.play(idle)
	
	if direction and not can_walk:
		idle = "stand"

func _on_timer_timeout() -> void:
	if scratching: pass
	idle = "sit"
	can_walk = false
	anim.play(idle)

func _on_animated_sprite_2d_animation_finished() -> void:
	match idle:
		"sit":
			if not running:
				idle = "idle"
			else:
				idle = "idle run"
				rest_time.start()
		"stand":
			can_walk = true
			print("pode andar")
			idle = "idle stand"
		
	match movement:
		"wall sup":
			print("meow")
			movement = "wall scratch"
			scratch.emitting = true
		"wall out":
			scratch.emitting = false
			scratching = false
			can_walk = true
	#if anim.animation == "falling":
	#	jumping = false
		#anim.set_frame_and_progress(4,0)
		

func _on_run_timer_timeout() -> void:
	running = true


func _on_rest_time_timeout() -> void:
	running = false
