extends Node2D

const BrickScene := preload("res://Brick.tscn") # what does this do
const COLS := 10
const ROWS := 5

# @onready assigns value after node has entered scene tree
@onready var paddle := $Paddle
@onready var ball := $Ball
@onready var label: Label = $UI/Label

var score := 0
var lives := 3
var bricks_left := 0
var game_over := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	paddle.add_to_group("paddle")
	_make_wall(Vector2(-10,300),Vector2(20,600)) #leftwall
	_make_wall(Vector2(810,300),Vector2(20,600)) #rightwall
	_make_wall(Vector2(400,-10),Vector2(800,20)) #topwall
	_spawn_bricks()
	ball.lost.connect(_on_ball_lost)
	_update_ui()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if game_over:
		if Input.is_action_just_pressed("launch"):
			get_tree().reload_current_scene()
		return
	if not ball.launched:
		ball.global_position = paddle.global_position + Vector2(0,-24)
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
		game_over = true
		label.text = "You win! Score: %d (Space to restart)" % score
		return
	_update_ui()
	

func _on_ball_lost() -> void:
	lives -= 1
	if lives <= 0:
		game_over = true
		label.text = "Game over! Score: %d (Space to restart)" % score
		
func _update_ui() -> void:
	label.text = "Score: %d    Lives: %d" % [score,lives]
