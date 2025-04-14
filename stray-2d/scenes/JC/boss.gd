extends Node2D

var dir = 1
var last_dir = 1
var speed = 100.0
var killed = 1

@onready var timer: Timer = $Timer
@onready var detect_left: RayCast2D = $Detect_left
@onready var detect_right: RayCast2D = $Detect_right
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var player := $"../Player"

func _ready() -> void:
	animation.play("walking")
	print("Come fight me")

func _process(delta: float) -> void:
	if player == null:
		return

	var direction = player.global_position.x - global_position.x
	
	if abs(direction) > 5:  # margem pra não tremer quando estiver colado no player
		dir = sign(direction)
		animation.flip_h = dir < 0
		position.x += dir * speed * delta * killed
		
		
	if detect_left.is_colliding():
		timer.start()
		dir = 1
		animation.flip_h = false
	if detect_right.is_colliding():
		timer.start()
		dir = -1
		animation.flip_h = true
		
	if (last_dir == dir): 
		speed = speed + (5 * delta)
	else:
		speed = 0
		last_dir = dir
		
	position.x += 3 * speed * delta * dir * killed
		
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
	get_node(".").queue_free()
