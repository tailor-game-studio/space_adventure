extends Node2D

export (int) var speed = 150
export (Texture) var _texture

func _ready():
	$Sprite.texture = _texture
	$Sprite2.texture = _texture

func _process(delta):
	position.x -= speed * delta
	if global_position.x < -get_viewport().size.x:
		position.x = 0
