extends Node2D

export (PackedScene) var Boss : PackedScene

var _Enemy_Scene = preload("res://enemy/scene/Enemy.tscn")
var _screen_size :Vector2
var _life
var _score

func _ready():
	randomize()
	_init_ui()
	_screen_size = get_viewport_rect().size
	$GameOverLabel.hide()

func _init_ui():
	_life = AutoLoad._life
	_score = AutoLoad._score
	$GameUI._update_score(_score)
	for i in _life:
		$GameUI._add_life()

func _on_EnemyLoader_timeout():
	var enemy = _Enemy_Scene.instance()
	enemy.position = Vector2(_screen_size.x + 50, rand_range(35, _screen_size.y - 35))
	enemy.connect("destroy", self,"_on_Enemy_destroy")
	add_child(enemy)
	_enemy_attack(enemy)

func _on_Enemy_destroy():
	_score += 100
	$GameUI._update_score(_score)

func _enemy_attack(enemy):
	var bullet = enemy.BulletScene.instance()
	bullet.is_enemy = true
	bullet.position = enemy.get_node("BulletPosition").global_position
	add_child(bullet)

func _on_Player_destroy():
	_life -= 1
	if _life < 0: _game_over()
	else:
		$GameUI._reduce_life() 
		$RestorePlayer.start()

func _on_RestorePlayer_timeout():
	$Player.show()
	$Player/PlayerEffect.start()

func _game_over():
	$GameOverLabel.show()
	$GameOverDelay.start()

func _on_GameOverDelay_timeout():
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://ui/scene/Main.tscn")

func _on_GameTimer_timeout():
	var boss = _load_boss()
	$EnemyLoader.stop()
	yield(get_tree().create_timer(3), "timeout")
	$Player._can_play = false
	yield(get_tree().create_timer(2), "timeout")
	boss._move_on()
	yield(get_tree().create_timer(2), "timeout")
	$Player._can_play = true
	boss.get_node("CollisionPolygon2D").disabled = false

func _load_boss():
	var boss = Boss.instance()
	boss.position = $BossPosition.position
	boss.connect("dead", self, "_on_boss_defeated")
	add_child(boss)
	return boss

func _on_boss_defeated():
	_score += 1000
	yield(get_tree().create_timer(2), "timeout")
	$Player._can_play = false
	yield(get_tree().create_timer(3), "timeout")
	$Player._move_on()