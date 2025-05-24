extends Control

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/JC/main_menu.tscn")

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Levels/Level 1.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
