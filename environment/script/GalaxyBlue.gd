extends "res://environment/script/Environment.gd"

func _on_Player_load_next_step():
	yield(get_tree().create_timer(2), "timeout")
	AutoLoad._score = _score
	AutoLoad._life = _life
	get_tree().change_scene("res://transition/scene/Transition.tscn")