extends Node2D

func _ready() -> void:
	Global.score=0

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/World Scenes/main.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()