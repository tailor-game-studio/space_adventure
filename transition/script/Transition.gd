extends Control

const STAGE = "Stage : "

var scene_blue = "res://environment/scene/GalaxyBlue.tscn"
var scene_black = "res://environment/scene/GalaxyBlack.tscn"

func _ready():
	$CenterContainer/VBoxContainer/Stage.text = STAGE + str(AutoLoad._stage)
	$CenterContainer/VBoxContainer/Name.text = AutoLoad._stage_name

func _on_Timer_timeout():
	if AutoLoad._stage == 1:
		AutoLoad._stage = 2
		AutoLoad._stage_name = "Galaxy Black"
		get_tree().change_scene(scene_blue)
	else: 
		get_tree().change_scene(scene_black)
