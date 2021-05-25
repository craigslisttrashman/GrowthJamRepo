extends KinematicBody2D

# Declare member variables here. Examples:
var moveSpeed = 1
var angle = Vector2(0,0)
var inputVector = Vector2(0,0)
var animationState = 0

onready var animator = $AnimationPlayer
onready var sprite = $Sprite

onready var bullet = preload("res://Bullet/Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("Idle", -1, 1, false) 
	pass 



func _physics_process(delta):
	#Finding Controller Inputs
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if (abs(inputVector.x) > 0.5):
		sprite.scale.x = sign(-inputVector.x)
	
	#Movement Functionality
	if(abs(inputVector.x) > 0.5 && !Input.is_action_pressed("ui_hold")):
		if(inputVector.y < -.4):
			animator.play("WalkLeftAngled", -1, 1, false)
			angle = Vector2(sign(inputVector.x), -1)
		else:
			animator.play("WalkLeft", -1, 1, false)
			angle = Vector2(sign(inputVector.x), 0)
		move_and_collide(sign(inputVector.x) * Vector2.RIGHT * moveSpeed)
	else:
		if (inputVector.y < -.6 && abs(inputVector.x) < 0.5):
			animator.play("UpIdle", -1, 1, false)
			angle = Vector2(0, -1)
		elif (inputVector.y < -.4):
			animator.play("AngleIdle", -1, 1, false)
		else:
			animator.play("Idle", -1, 1, false)
			angle = Vector2(-sprite.scale.x, 0)
			
	#Shooting
	if (Input.is_action_just_pressed("ui_shoot")):
		print("Shoot!")
		var newbullet = bullet.instance()
		newbullet.transform.origin.x = transform.origin.x
		newbullet.transform.origin.y = transform.origin.y
		newbullet.angleshot(angle.normalized() * 4, 0)
		get_parent().add_child(newbullet)
