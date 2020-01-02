extends Control

func _ready():
	pass

func _on_Play_pressed():
	get_tree().change_scene("res://transition/scene/Transition.tscn")

func _on_Exit_pressed():
	get_tree().quit()
	pass # Replace with function body.
