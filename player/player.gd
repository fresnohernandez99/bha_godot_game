extends KinematicBody2D

export (int) var speed = 100
export (int) var gravity = 100

signal CoinCollected(points)
signal Lose(points)

var life = 3
var flyTime = 0
var mov = Vector2()
var viewPortRange = Vector2()
var actualPoints = 0
var shieldActivated = false

var actualAnim = "max"

var actualFlySpeed = 1
const increasse = 3

var actualHorizontalSpeed = 1

var shipIsOn = "center"

#nodes
onready var bodySprite = $BodySprite
onready var propSprite = $PropSprite
onready var trailerSprite = $Trailer
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
	
	var up = int(Input.is_action_pressed("ui_up")) 
	var down = int(Input.is_action_pressed("ui_down"))
	var right = int(Input.is_action_pressed("ui_right"))
	var left = int(Input.is_action_pressed("ui_left"))
	
	if right:
		turnRight()
		bodySprite.play(actualAnim + "_right")
	if left:
		turnLeft()
		bodySprite.play(actualAnim + "_left")
	
	if !right and !left:
		bodySprite.play(actualAnim + "_idle")
		turnCenter()
		gradualStop()
	
	if rotation_degrees < 0:
		shipIsOn = "left"
	
	if rotation_degrees > 1:
		shipIsOn = "right"
	
	if Input.is_action_just_released("ui_up"):
		propSprite.play("stop")
	
	updateFlyBar()
	
	goUpGoDown(up, down, delta)
	
	if is_on_floor() and flyTime > 0:
		flyTime -= 0.03
	
	if is_on_floor():
		turnCenter()
	
	if position.y >= 145:
		trailerSprite.play("land")
	else: 
		trailerSprite.play("go")
	
	position.x = clamp(position.x, 0, viewPortRange.x)
	position.y = clamp(position.y, 0, viewPortRange.y)
	
	move_and_slide(Vector2(actualHorizontalSpeed, mov.y), Vector2(0,-1))

func updateFlyBar():
	if flyTime <= 0:
		flyBar.frame = 0
	elif flyTime >=2 and flyTime < 4:
		flyBar.frame = 1
	elif flyTime >=4 and flyTime < 6:
		flyBar.frame = 2
	elif flyTime >=6 and flyTime < 8:
		flyBar.frame = 3
	elif flyTime >=8 and flyTime < 10:
		flyBar.frame = 4
	elif flyTime >=10:
		flyBar.frame = 5
		propSprite.play("stop")

func turnLeft():
	if actualHorizontalSpeed > (speed * -1):
		actualHorizontalSpeed -= increasse *2
	if rotation_degrees > -20 and !is_on_floor():
		rotation_degrees -= 1

func turnRight():
	if actualHorizontalSpeed < (speed * 1):
		actualHorizontalSpeed += increasse *2
	if rotation_degrees < 20 and !is_on_floor():
		rotation_degrees += 1

func turnCenter():
	var aux
	if shipIsOn == "left":
		aux = 1
	if shipIsOn == "right":
		aux = -1
	if rotation_degrees < 0 or rotation_degrees > 1:
		rotation_degrees += aux
	else:
		shipIsOn = "center"

func goUpGoDown(up, down, delta):
	if up and flyTime <= 10:
		if actualFlySpeed < speed:
			actualFlySpeed += increasse
		mov.y = -1 * actualFlySpeed
		flyTime += delta * 0.6
		propSprite.play("fly")
	else:
		if actualFlySpeed > 1:
			actualFlySpeed -= increasse
		mov.y = gravity - actualFlySpeed
	if down:
		mov.y = speed + 50

func gradualStop():
	if is_on_floor():
		if actualHorizontalSpeed  < 0:
			actualHorizontalSpeed += 1
		else:
			actualHorizontalSpeed -= 1
	else:
		if actualHorizontalSpeed  < 0:
			actualHorizontalSpeed += 0.5
		else:
			actualHorizontalSpeed -= 0.5

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
	speed = 170
	speedPower.show()
	speedTimer.start()

func getShieldPower():
	shieldActivated = true
	shieldPower.show()
	shieldTimer.start()

func _on_SpeedTimer_timeout():
	speed = 100
	speedPower.hide()

func _on_ShieldTimer_timeout():
	shieldActivated = false
	shieldPower.hide()

func _on_HitTimeSHowIn_timeout():
	pass # Replace with function body.

