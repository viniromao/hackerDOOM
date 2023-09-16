extends Node2D

@onready var spawn_player_pos = $PlayerSpawnPos
@onready var laser_container = $LaserContainer
@onready var gos = $gameOverLayer/GameOver

@export var player_initial_position = Vector2(0,0)
@export var scroll_speed = 20.0

@onready var bg1 = $bg1
@onready var bg2 = $bg2

var bg_width

func pad_with_zeros(number, width):
	var str_num = str(number)
	while str_num.length() < width:
		str_num = "0" + str_num
	return str_num

var score = 0
var lives = 3

var timer = 0
@export var spawnTime = .5

var path1 = preload("res://paths/path1.tscn")
var path2 = preload("res://paths/path2.tscn")
var path3 = preload("res://paths/path3.tscn")
var enemy_scene = preload("res://actors/enemy.tscn")

var player = null

func _ready():
	bg_width = bg1.texture.get_width()
	bg2.position.x = bg_width + 80
	player = get_tree().get_first_node_in_group("player")
	assert(player != null)
	player.global_position = spawn_player_pos.global_position
	player.laser_shot.connect(_on_player_laser_shot)
	player.killed.connect(_on_player_killed)

func _process(delta):
	bg1.position.x -= scroll_speed * delta
	bg2.position.x -= scroll_speed * delta

	if bg1.position.x <= -bg_width + 80:
		bg1.position.x = bg2.position.x + bg_width

	if bg2.position.x <= -bg_width + 80:
		bg2.position.x = bg1.position.x + bg_width
	
	
	var padded_score = pad_with_zeros(score, 8) 
	$score.text = "scr: " + padded_score
	var padded_lives = pad_with_zeros(lives, 2) 
	$lives.text = "<" + padded_lives
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	spawnThings(delta)
		
func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)
	
func spawnThings(delta):
	timer += delta
	if (timer > spawnTime):
#		var path1Instance = path1.instantiate()
#		var path2Instance = path2.instantiate()
		var path3Instance = path3.instantiate()
#		add_child(path1Instance)
#		add_child(path2Instance)
		add_child(path3Instance)
		timer = 0
	

func increase_score(value):
	score += value
	
func decrease_lives():
	lives -= 1

func _on_player_killed():
	await get_tree().create_timer(0.5).timeout
	gos.visible = true
