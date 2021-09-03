extends Area2D

var toked = false

#nodes
onready var sprite = $AnimatedSprite
onready var timerOut = $TimerOut
onready var collision = $CollisionShape2D

func _ready():
	randomize()
	sprite.play("idle")

func _on_Coin_body_entered(body):
	if body.is_in_group("player") and !toked:
		sprite.animation = "toked"
		sprite.play()
		if body.life < 3:
			body.setLife(body.life + 1)
		toked = true
		timerOut.start()

func _on_TimeToGo_timeout():
	if !toked:
		queue_free()

func _on_TimerOut_timeout():
	queue_free()
