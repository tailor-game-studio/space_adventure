extends Area2D

export (PackedScene) var BulletScene
export (PackedScene) var Explosion_Scene :PackedScene
export (int) var move_speed = 250

var _screen_size : Vector2
var _player_effect = 0
var _can_play = true

signal destroy
signal load_next_step

func _ready():
	_screen_size = get_viewport_rect().size

func _process(delta):
	if _can_play:
		_on_move(delta)
		_restrict_move()
		_on_attack()

func _on_move(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	position +=  velocity * move_speed * delta

func _restrict_move():
	position.x = clamp(position.x, 35, _screen_size.x - 35)
	position.y = clamp(position.y, 35, _screen_size.y - 35)

func _on_attack():
	if Input.is_action_just_pressed("fire"):
		var bInstance = BulletScene.instance()
		bInstance.position = $BulletPosition.global_position
		get_parent().add_child(bInstance)

func _on_Player_area_entered(area):
	var eInstance = Explosion_Scene.instance()
	eInstance.position = global_position
	if area.is_in_group("bullet") and area.is_enemy || area.is_in_group("enemy") || area.is_in_group("asteroid"):
		get_parent().add_child(eInstance)
		area.queue_free()
		hide()
		$CollisionPolygon2D.set_deferred("disabled", true)
		emit_signal("destroy")

func _on_PlayerEffect_timeout():
	_player_effect += 1
	visible = !visible
	if _player_effect == 30:
		_player_effect = 0
		visible = true
		$PlayerEffect.stop()
		$CollisionPolygon2D.disabled = false

func _move_on():
	$AnimationPlayer.add_animation("MOVE_ON", _create_animation())
	$AnimationPlayer.play("MOVE_ON")

func _create_animation():
	var anim = Animation.new()
	anim.length = 2.0
	var track_index = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(track_index, ".:position")
	anim.track_insert_key(track_index, 0.0, position)
	anim.track_insert_key(track_index, 2.0, Vector2(_screen_size.x + 50, position.y))
	return anim

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("load_next_step")
	queue_free()
