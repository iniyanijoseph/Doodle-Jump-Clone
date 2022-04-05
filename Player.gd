extends KinematicBody2D


var velocity = Vector2.ZERO
var jumpforce = 300
var gravity = 300
var speed = 300
var jump = false
onready var greenplatform = preload("res://Green Platform.tscn")
onready var brownplatform = preload("res://Brown Platform.tscn")
onready var blueplatform = preload("res://Blue Platform.tscn")
onready var platforms = [greenplatform, greenplatform, greenplatform, brownplatform, blueplatform, blueplatform]
var height = 100

func _ready():
	randomize()

func move(delta):
	if Input.is_action_pressed("Right") or Input.get_accelerometer().x > 0:
		velocity.x = speed
		$Camera2D.position.x -= speed*delta
	elif Input.is_action_pressed("Left") or Input.get_accelerometer().x < 0:
		velocity.x = -speed
		$Camera2D.position.x += speed*delta
	else:
		velocity.x = 0

	if jump:
		velocity.y = -jumpforce

	velocity = move_and_slide(velocity, Vector2.UP)

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("Brown Platform"):
			collision.collider.queue_free()

	if is_on_floor():
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if not collision.collider.is_in_group("Brown Platform"):
				jump = true
	else:
		jump = false

	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y += gravity * delta

	if position.x > 266 or position.x < -266:
		position.x *= -1
		$Camera2D.position *= -1

func animations():
	if Input.is_action_pressed("Right") or Input.get_accelerometer().x > 0:
		$Sprite.flip_h = true
	if Input.is_action_pressed("Left") or Input.get_gyroscope().x < 0:
		$Sprite.flip_h = false

func restart():
	if Input.is_key_pressed(KEY_R):
		var _x = get_tree().reload_current_scene()

func _process(delta):
	restart()
	move(delta)
	animations()
	var node = platforms[int(rand_range(0, len(platforms)))].instance()
	node.position.x = int(rand_range(-266, 266))
	node.position.y = height
	height -= 60
	get_parent().get_parent().add_child(node)
