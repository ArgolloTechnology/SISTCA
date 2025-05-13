extends Node2D

var dir = 1
var last_dir = 1
var speed = 0
var killed = 1

@onready var detect_left: RayCast2D = $Detect_left
@onready var detect_right: RayCast2D = $Detect_right
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"../Player"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("walking")
	print("Come fight me")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if detect_left.is_colliding():
		dir = 1
		animation.flip_h = false
	if detect_right.is_colliding():
		dir = -1
		animation.flip_h = true
		
	if (last_dir == dir): 
		speed = speed + (4 * delta)
	else:
		speed = 0
		last_dir = dir

func _physics_process(delta: float) -> void:
	position.x += 3 * speed * delta * dir * killed

func restartlevel():
	get_tree().reload_current_scene()

func killcat():
	get_node("Kill_hitbox/CollisionShape2D").queue_free()
	get_node("deal_dmg_to_player/CollisionShape2D").queue_free()
	self.freeze = true
	self.collision_layer = 0
	player.velocity.y = -200

# Levar hit de inimigo
func _on_damage_hitbox_body_entered(_body: Node2D) -> void:
	print("Morreu")
	call_deferred("restartlevel")

# Matar o inimigo
func _on_kill_hitbox_body_entered(_body: Node2D) -> void:
	killed = 0
	animation.play("death")
	call_deferred("killcat")

# Quando a animaçao de morto acabar remover nodo do inimigo
func _on_animated_sprite_2d_animation_finished() -> void:
	get_node(".").queue_free()
