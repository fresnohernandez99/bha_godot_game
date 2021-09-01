extends KinematicBody2D

var isMoving = false
export (int) var speed = 60
var mov = Vector2()
var direction = 0
var timeLeft = 3

#nodes
onready var changeDir = $ChangeDir
onready var tween = $Tween

func _ready():
	randomize()
	timeLeft = int(rand_range(2, 4))
	changeDir.wait_time = timeLeft
	changeDir.start()
	#setSpeed(100)
	#setDirectionAndStart(3)

func setSpeed(sp):
	speed = sp

func setDirectionAndStart(dir):
	direction = dir
	match(dir):
		#up
		0:
			mov = Vector2(0, -1 * speed)
			tween.interpolate_property(self, "rotation_degrees", 0, -360, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		#down
		1:
			mov = Vector2(0, 1 * speed)
			tween.interpolate_property(self, "rotation_degrees", 0, -360, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		#right
		2:
			mov = Vector2(1 * speed, 0)
			tween.interpolate_property(self, "rotation_degrees", 0, 360, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		#left
		3:
			mov = Vector2(-1 * speed, 0)
			tween.interpolate_property(self, "rotation_degrees", 0, -360, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	isMoving = true
	tween.start()

func _physics_process(delta):
	if isMoving:
		move_and_slide(mov, Vector2(0,-1))

func changeDirection():
	match(direction):
		0:
			mov = Vector2(0, 1 * speed)
			tween.interpolate_property(self, "rotation_degrees", rotation_degrees, rotation_degrees+360, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		1:
			mov = Vector2(0, -1 * speed)
			tween.interpolate_property(self, "rotation_degrees", rotation_degrees, rotation_degrees+360, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		2:
			mov = Vector2(-1 * speed, 0)
			tween.interpolate_property(self, "rotation_degrees", rotation_degrees, rotation_degrees-360, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		3:
			mov = Vector2(1 * speed, 0)
			tween.interpolate_property(self, "rotation_degrees", rotation_degrees, rotation_degrees+360, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_ChangeDir_timeout():
	changeDirection()


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.setLife(body.life - 1)
		queue_free()
