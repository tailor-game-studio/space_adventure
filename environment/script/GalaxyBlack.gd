extends "res://environment/script/Environment.gd"

func _on_Player_load_next_step():
	get_tree().change_scene("res://ui/scene/Main.tscn")
