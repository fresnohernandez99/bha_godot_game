extends KinematicBody2D

export (int) var speed = 170
export (int) var gravity = 200

signal CoinCollected(points)
signal Lose(points)

var life = 3
var flyTime = 0
var mov = Vector2()
var viewPortRange = Vector2()
var actualPoints = 0
var shieldActivated = false

var actualAnim = "max"

#nodes
onready var bodySprite = $BodySprite
onready var flyBar = $Gui/FlyBar
onready var tween = $Tween
onready var hitTimeShowIn = $HitTimeShowIn
onready var shieldPower = $ShieldSprite
onready var shieldTimer = $ShieldTimer
onready var speedPower = $SpeedSprite
onready var speedTimer = $SpeedTimer

func _ready():
	viewPortRange = get_viewport_rect().size

func _physics_process(delta):
	movement(delta)

func movement(delta):
	mov = Vector2()
	
	#movimientos
	var up = int(Input.is_action_pressed("ui_up")) 
	var down = int(Input.is_action_pressed("ui_down"))
	var right = int(Input.is_action_pressed("ui_right"))
	var left = int(Input.is_action_pressed("ui_left"))
	
	#sonidos de movimeintos
	if int(Input.is_action_just_pressed("ui_right")):
		pass
		#$giros.play()
	if int(Input.is_action_just_pressed("ui_left")):
		pass
		#$giros.play()
	
	if Input.is_action_just_released("ui_up"):
		bodySprite.play("idle_" + actualAnim)
		
	
	#barra
	if flyTime <= 0:
		flyBar.frame = 0
	elif flyTime >=1 and flyTime < 2:
		flyBar.frame = 1
	elif flyTime >=2 and flyTime < 3:
		flyBar.frame = 2
	elif flyTime >=3 and flyTime < 4:
		flyBar.frame = 3
	elif flyTime >=4 and flyTime < 5:
		flyBar.frame = 4
	elif flyTime >=5:
		flyBar.frame = 5
		bodySprite.play("idle_" + actualAnim)
	
	if(right):
		mov.x =1
		#$NSprite.animation = "derecha"
	if(left):
		mov.x =-1
		#$NSprite.animation = "izkierda"
	
	if up and flyTime <= 5:
		mov.y = -1 * speed
		flyTime += delta * 0.6
		bodySprite.play("fly_" + actualAnim)
		
	else:
		mov.y = gravity 
	if down:
		mov.y = 2 * speed
		
	if is_on_floor() and flyTime > 0:
		flyTime -= 0.03
		
	position.x = clamp(position.x, 0, viewPortRange.x)
	position.y = clamp(position.y, 0, viewPortRange.y)
	
	move_and_slide(Vector2(mov.x * speed,mov.y), Vector2(0,-1))

func setLife(lf):
	if life > lf:
		if shieldActivated:
			pass
		else:
			life = lf
			getHit()
	else:
		life = lf
		
	match life:
		0:
			emit_signal("Lose", actualPoints)
		1:
			actualAnim = "final"
		2:
			actualAnim = "mid"
		3:
			actualAnim = "max"
	if life > 3:
		actualAnim = "max"
	
	bodySprite.play("idle_" + actualAnim)

func collected(points):
	actualPoints += points
	emit_signal("CoinCollected", actualPoints)

func extraBat():
	flyTime = 0

func getHit():
	tween.interpolate_property(bodySprite, "modulate",  Color( 1, 1, 1, 1 ),  Color( 1, 0.2, 0.2, 1 ), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	hitTimeShowIn.start()
	yield(hitTimeShowIn, "timeout")
	tween.interpolate_property(bodySprite, "modulate",  modulate,  Color( 1, 1, 1, 1 ), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func getSpeedPower():
	speed = 270
	speedPower.show()
	speedTimer.start()

func getShieldPower():
	shieldActivated = true
	shieldPower.show()
	shieldTimer.start()

func _on_SpeedTimer_timeout():
	speed = 170
	speedPower.hide()


func _on_ShieldTimer_timeout():
	shieldActivated = false
	shieldPower.hide()



































func _on_HitTimeSHowIn_timeout():
	pass # Replace with function body.

