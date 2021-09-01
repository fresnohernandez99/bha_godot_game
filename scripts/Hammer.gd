extends KinematicBody2D

var isMoving = false
export (int) var speed = 70
var mov = Vector2()

func _ready():
	#setSpeed(100)
	#setDirectionAndStart(3)
	pass

func setSpeed(sp):
	speed = sp

func setDirectionAndStart(dir):
	match(dir):
		#up
		0:
			mov = Vector2(0, -1 * speed)
		#down
		1:
			rotation_degrees = 180
			mov = Vector2(0, 1 * speed)
		#right
		2:
			rotation_degrees = 90
			mov = Vector2(1 * speed, 0)
		#left
		3:
			rotation_degrees = 270
			mov = Vector2(-1 * speed, 0)
	isMoving = true

func _physics_process(delta):
	if isMoving:
		move_and_slide(mov, Vector2(0,-1))


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.setLife(body.life - 1)
		queue_free()
