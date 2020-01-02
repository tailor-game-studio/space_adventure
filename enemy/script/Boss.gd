extends Area2D

#Our Animation name
const MOVE_ON = "Move_On"
const MOVE_FROM_CENTER_TO_UP = "Move_center_to_up"
const MOVE_FROM_UP_TO_CENTER = "Move_up_to_center"
const MOVE_FROM_CENTER_TO_BOTTOM = "Move_center_to_bottom"
const MOVE_FROM_BOTTOM_TO_CENTER = "Move_bottom_to_center"

#All export Var
export (PackedScene) var BulletScene :PackedScene
export (float) var _animation_end_time
export (int) var _life

#Preload Var
var ExplosionScene = preload("res://fire_effect/scene/Explosion.tscn")

#Normal Var
var _animation_start_time = 0.0
var _initial_pos : Vector2
var _screen_size : Vector2

#signal
signal dead

func _ready():
	_screen_size = get_viewport_rect().size
	$MoveAnimation.add_animation(MOVE_ON, _create_animation(MOVE_ON))

func _move_on():
	$MoveAnimation.play(MOVE_ON)

func _create_animation(anim_name):
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, ".:position")
	if anim_name == MOVE_ON:
		animation.track_insert_key(track_index, _animation_start_time, position)
		animation.track_insert_key(track_index, _animation_end_time, Vector2(_screen_size.x - 100, position.y))
	elif anim_name == MOVE_FROM_CENTER_TO_UP:
		animation.track_insert_key(track_index, _animation_start_time, position)
		animation.track_insert_key(track_index, _animation_end_time, Vector2(position.x, 40))
	elif anim_name == MOVE_FROM_CENTER_TO_BOTTOM:
		animation.track_insert_key(track_index, _animation_start_time, position)
		animation.track_insert_key(track_index, _animation_end_time, Vector2(position.x, _screen_size.y-40))
	else:
		animation.track_insert_key(track_index, _animation_start_time, position)
		animation.track_insert_key(track_index, _animation_end_time, _initial_pos)
	return animation

func _on_MoveAnimation_animation_finished(anim_name):
	yield(get_tree().create_timer(1), "timeout")
	$BulletLoader.start()
	if anim_name == MOVE_ON:
		_initial_pos = position
		_create_if_not_exist(MOVE_FROM_CENTER_TO_UP)
		$MoveAnimation.play(MOVE_FROM_CENTER_TO_UP)
	elif anim_name == MOVE_FROM_CENTER_TO_UP:
		_create_if_not_exist(MOVE_FROM_UP_TO_CENTER)
		$MoveAnimation.play(MOVE_FROM_UP_TO_CENTER)
	elif anim_name == MOVE_FROM_UP_TO_CENTER:
		_create_if_not_exist(MOVE_FROM_CENTER_TO_BOTTOM)
		$MoveAnimation.play(MOVE_FROM_CENTER_TO_BOTTOM)
	elif anim_name == MOVE_FROM_CENTER_TO_BOTTOM:
		_create_if_not_exist(MOVE_FROM_BOTTOM_TO_CENTER)
		$MoveAnimation.play(MOVE_FROM_BOTTOM_TO_CENTER)
	else:
		$MoveAnimation.play(MOVE_FROM_CENTER_TO_UP)

func _create_if_not_exist(anim_name):
	if !$MoveAnimation.has_animation(anim_name):
		$MoveAnimation.add_animation(anim_name, _create_animation(anim_name));

func _on_BulletLoader_timeout():
	var bullet = BulletScene.instance()
	bullet.position = $BulletPosition.global_position
	bullet.is_enemy = true
	get_parent().add_child(bullet)
	yield(get_tree().create_timer(0.3), "timeout")


func _on_Boss_area_entered(area):
	if area.is_in_group("bullet") and !area.is_enemy:
		$BulletTouchEffect.start()
		_life -= 1
		area.queue_free()
		if _life == 0:
			queue_free()
			$MoveAnimation.stop()
			_on_boss_dead()

func _on_BulletTouchEffect_timeout():
	visible = !visible
	yield(get_tree().create_timer(0.1), "timeout")
	visible = true

func _on_boss_dead():
	var explosion = ExplosionScene.instance()
	explosion.scale.x = 2.5
	explosion.scale.y = 2.5
	explosion.position = global_position
	get_parent().add_child(explosion)
	emit_signal("dead")
