extends Node2D

const BrickScene := preload("res://Brick.tscn") #loads the bricks into scene
const COLS := 10
const ROWS := 5

# @onready assigns value after node has entered scene tree
@onready var paddle := $Paddle
@onready var ball := $Ball
@onready var label: Label = $UI/UpperLeftUI
@onready var startbutton: Button = $UI/StartButton
@onready var title: Label = $UI/TitleText
@onready var restart: Button = $UI/RestartButton

var score := 0
var lives := 3
var bricks_left := 0
var game_over := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Game Music".play()
	restart.hide()
	paddle.hide()
	ball.hide()
	startbutton.pressed.connect(_start_button_pressed)
	ball.lost.connect(_on_ball_lost)
	_update_ui()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if game_over:
		_game_over()
	if not ball.launched:
		ball.global_position = paddle.global_position + Vector2(0,-20)
		if Input.is_action_just_pressed("launch"):
			ball.launch()

func _make_wall(pos:Vector2,size:Vector2) -> void:
	var body := StaticBody2D.new()
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	shape.shape = rect
	body.position = pos
	body.add_child(shape)
	add_child(body)

func _spawn_bricks() -> void:
	var colors := [Color.RED,Color.ORANGE,Color.YELLOW,Color.GREEN,Color.AQUA]
	for row in ROWS:
		for col in COLS:
			var brick := BrickScene.instantiate()
			brick.position = Vector2(58+col*76,80+row*28)
			brick.get_node("ColorRect").color = colors[row]
			brick.destroyed.connect(_on_brick_destroyed)
			add_child(brick)
			bricks_left += 1
			
func _on_brick_destroyed() -> void:
	score += 10
	bricks_left -= 1
	if bricks_left == 0:
		# insert game over winning function with label update showing UI
		game_over = true
		paddle.process_mode = Node.PROCESS_MODE_DISABLED
		title.text = "You win! Score: %d" % score
		title.add_theme_font_size_override("font_size",24)
		title.show()
		restart.show()
		restart.pressed.connect(_restart_button_pressed)
		return
	_update_ui()
	

func _on_ball_lost() -> void:
	$BallLostSound.play() 
	lives -= 1
	_update_ui()
	if lives <= 0:
		game_over = true
		
func _update_ui() -> void:
	label.text = "Score: %d    Lives: %d" % [score,lives]

func _start_button_pressed():
	startbutton.hide()
	title.hide()
	ball.show()
	paddle.show()
	paddle.add_to_group("paddle")
	_make_wall(Vector2(-10,300),Vector2(20,600)) #leftwall
	_make_wall(Vector2(810,300),Vector2(20,600)) #rightwall
	_make_wall(Vector2(400,-10),Vector2(800,20)) #topwall
	_spawn_bricks()

func _restart_button_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")
	
func _game_over():
	paddle.process_mode = Node.PROCESS_MODE_DISABLED
	title.text = 'Game Over! Score: %d' % score
	title.add_theme_font_size_override("font_size",24)
	title.show()
	restart.show()
	restart.pressed.connect(_restart_button_pressed)
	
	
