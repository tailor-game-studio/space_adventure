extends MarginContainer

export (PackedScene) var PlayerLife : PackedScene

const SCORE = "SCORE : "

func _ready():
	_update_score(0)

func  _update_score(score):
	$HSplitContainer/Score.text = SCORE + str(score)

func _reduce_life ():
	$HSplitContainer/CenterContainer/HBoxContainer.get_child(0).queue_free()

func _add_life():
	if $HSplitContainer/CenterContainer/HBoxContainer.get_child_count() < 5:
		var instance = PlayerLife.instance()
		$HSplitContainer/CenterContainer/HBoxContainer.add_child(instance)
