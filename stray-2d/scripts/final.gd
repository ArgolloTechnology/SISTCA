extends Area2D

var NextLevelPath

func _ready() -> void:
	NextLevelPath = get_meta("NextLevelPath")
	if NextLevelPath == '':
		NextLevelPath = get_meta("MainMenuPath")
	print(NextLevelPath)

func changelevel():
	get_tree().change_scene_to_file(NextLevelPath)
	print("res://scenes/main_menu.tscn")

func _on_body_entered(_body):
	print("Proximo nivel")
	call_deferred("changelevel")
	
