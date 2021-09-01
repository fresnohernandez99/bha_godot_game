extends RigidBody2D

var timeLeft = 1 

#nodes
onready var bombTic = $BombTic
onready var sprite = $AnimatedSprite
onready var areaCollision = $Area2D/CollisionShape2D
onready var disapear = $DisapearExplotion
  
func _ready():
	randomize()
	timeLeft = int(rand_range(1, 4))
	bombTic.wait_time = timeLeft
	bombTic.start()
	sprite.play("idle")

func _process(delta):
	if bombTic.time_left == 1:
		sprite.animation = "toExplote"
		sprite.play()
 
func _on_BombTic_timeout():
	sleeping = true
	areaCollision.disabled = false
	sprite.animation = "explote"
	sprite.play()
	disapear.start()

func _on_DisapearExplotion_timeout():
	queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.setLife(body.life - 1)
		queue_free()
