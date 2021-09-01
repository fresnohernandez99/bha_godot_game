extends KinematicBody2D

var isMoving = false
export (int) var speed = 270
var mov = Vector2()

#node
onready var tween = $Tween
onready var sprite = $Sprite

func _ready():
	#setSpeed(100)
	#setDirectionAndStart(2)
	pass

func setSpeed(sp):
	speed = sp

func setDirectionAndStart(dir):
	match(dir):
		#right
		2:
			mov = Vector2(1 * speed, 0)
		#left
		3:
			sprite.flip_h = true
			mov = Vector2(-1 * speed, 0)
	isMoving = true
	if dir == 2:
		tween.interpolate_property(self, "rotation_degrees", 0, 360, 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	if dir == 3:
		tween.interpolate_property(self, "rotation_degrees", 0, -360, 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _physics_process(delta):
	if isMoving:
		move_and_slide(mov, Vector2(0,-1))
