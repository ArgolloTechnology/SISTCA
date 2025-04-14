extends Area2D


# Called when the node enters the scene tree for the first time.
func death():
	print("You plumbed to your death")
	get_tree().reload_current_scene()



func _on_body_entered(_body):
	call_deferred("death")
