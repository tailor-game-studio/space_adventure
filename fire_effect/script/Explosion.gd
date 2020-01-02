extends Node2D

func _ready():
	$Animation.play("Explosion Effect")

func _on_Animation_animation_finished(anim_name):
	queue_free()
