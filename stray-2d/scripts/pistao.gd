extends Node2D

@export var piston_left_path: NodePath
@export var piston_right_path: NodePath
@export var trigger_area_path: NodePath

@onready var piston_left: NodePath = get_node_or_null($"../piston_left_path")
@onready var piston_right: Node = get_node_or_null($"../piston_right")
@onready var trigger_area: Area2D = get_node_or_null(trigger_area_path)

func _ready() -> void:
	if piston_left and piston_right and trigger_area:
		trigger_area.body_entered.connect(_on_area_2d_body_entered)

func _on_area_2d_body_entered(body: Node) -> void:
		var anim_left = piston_left.get_node_or_null("AnimationPlayer")
		var anim_right = piston_right.get_node_or_null("AnimationPlayer")
		
		if anim_left and anim_right:
			anim_left.stop(true)
			anim_right.stop(true)
			anim_left.play("close")
			anim_right.play("close")
