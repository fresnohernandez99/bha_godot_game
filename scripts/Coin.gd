extends Area2D

var toked = false

#nodes
onready var sprite = $AnimatedSprite
onready var pointsLabel = $Points
onready var timerOut = $TimerOut
onready var collision = $CollisionShape2D

func _ready():
	randomize()
	sprite.play("idle")

func _on_Coin_body_entered(body):
	if body.is_in_group("player") and !toked:
		sprite.animation = "toked"
		sprite.play()
		var points = genPoints()
		body.collected(points)
		pointsLabel.text = str(points)
		toked = true
		timerOut.start()

func genPoints():
	return int(int(rand_range(1, 5)) * 50)

func _on_TimeToGo_timeout():
	if !toked:
		queue_free()

func _on_TimerOut_timeout():
	queue_free()
