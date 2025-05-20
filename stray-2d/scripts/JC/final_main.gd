extends Area2D


func changelevel():
	get_tree().change_scene_to_file("res://scenes/JC/nivel_inimigo.tscn")

func _on_body_entered(_body):
	print("Proximo nivel")
	call_deferred("changelevel")
	
