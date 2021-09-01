extends Node2D

var points = 0
var actualLevel = 1

var isInPause = false

var viewPortRange = Vector2()

#times
var cointGenTime = 3
var genTime_1 = 1
var bombGenTime = 4
var bladeGenTime = 10

var difficultyLevel = 0

#enemies
onready var hammer = preload("res://objects/enemies/Hammer.tscn")
onready var key = preload("res://objects/enemies/Key.tscn")

onready var bomb = preload("res://objects/enemies/Bomb.tscn")
onready var blades = preload("res://objects/enemies/Blades.tscn")

#points
onready var coin = preload("res://objects/points/Coin.tscn")
onready var coinExtraBat = preload("res://objects/points/ExtraBat.tscn")
onready var coinExtraLife = preload("res://objects/points/ExtraLife.tscn")

onready var powerCoins = [coinExtraBat, coinExtraLife]


#node
onready var player1 = $MainCanvas/Player
onready var timerGenCoin = $MainCanvas/Timers/Timer_GenCoin
onready var timerRegulars = $MainCanvas/Timers/Timer_Regulars
onready var timerBlades = $MainCanvas/Timers/Timer_Blades
onready var timerBombs = $MainCanvas/Timers/Timer_Bombs
onready var timerGenPowerCoins = $MainCanvas/Timers/Timer_GenPowerCoin
onready var timerPowerSpeed = $MainCanvas/Timers/TimerPowerSpeed
onready var timerPowerShield = $MainCanvas/Timers/TimerPowerShield 
onready var enemyGroup = $MainCanvas/EnemyGroup
onready var coinGroup = $MainCanvas/CoinGroup
onready var player1Points = $MainCanvas/Gui/Player1Points
onready var pauseDialog = $MainCanvas/Gui/PauseDialog
onready var loseDialog = $MainCanvas/Gui/LoseDialog
onready var timerToContinue = $MainCanvas/Timers/TimerToContinue
onready var continueLabel = $MainCanvas/Gui/ContinueLabel
onready var pointsOnDialog = $MainCanvas/Gui/LoseDialog/PointsOnDialog
onready var powerSpeedBtn = $MainCanvas/Gui/PowerBtns/SpeedPower
onready var powerShieldBtn = $MainCanvas/Gui/PowerBtns/ShieldPower
onready var powerSpeedLabel = $MainCanvas/Gui/PowerBtns/SpeedPower/Label
onready var powerShieldLabel = $MainCanvas/Gui/PowerBtns/ShieldPower/Label2

#positions
onready var firstPositions = [
	$MainCanvas/Positions/RegularPos_1,
	$MainCanvas/Positions/RegularPos_2,
	$MainCanvas/Positions/RegularPos_3,
	$MainCanvas/Positions/RegularPos_4,
	$MainCanvas/Positions/RegularPos_6,
	$MainCanvas/Positions/RegularPos_7,
	$MainCanvas/Positions/RegularPos_8
]

onready var topPositions = [
	$MainCanvas/Positions/RegularPos_9,
	$MainCanvas/Positions/RegularPos_10,
	$MainCanvas/Positions/RegularPos_11,
	$MainCanvas/Positions/RegularPos_12
]

onready var allPositions = [
	$MainCanvas/Positions/RegularPos_1,
	$MainCanvas/Positions/RegularPos_2,
	$MainCanvas/Positions/RegularPos_3,
	$MainCanvas/Positions/RegularPos_4,
	$MainCanvas/Positions/RegularPos_6,
	$MainCanvas/Positions/RegularPos_7,
	$MainCanvas/Positions/RegularPos_8,
	$MainCanvas/Positions/RegularPos_9,
	$MainCanvas/Positions/RegularPos_10,
	$MainCanvas/Positions/RegularPos_11,
	$MainCanvas/Positions/RegularPos_12
]

func _ready():
	randomize()
	timerToContinue.label = continueLabel
	viewPortRange = get_viewport_rect().size
	startGame()
	
	match int(Preferences.data.difficulty):
		0:
			pass
		25:
			difficultyLevel = 4
		50:
			difficultyLevel = 8
			genTime_1 = genTime_1 - 0.2
			bombGenTime = bombGenTime - 1
			bladeGenTime = bladeGenTime - 2
		75:
			difficultyLevel = 12
			genTime_1 = genTime_1 - 0.5
			bombGenTime = bombGenTime - 2
			bladeGenTime = bladeGenTime - 3
	

func _process(delta):
	matchActualLevel()
	getInput()

func getInput():
	if Input.is_action_just_pressed("A"):
		usingSpeedPower()
	if Input.is_action_just_pressed("S"):
		usingShieldPower()

func startGame():
	enemyGenerator()
	timerGenCoin.start()
	timerGenPowerCoins.start()
	timerPowerShield.start()
	timerPowerSpeed.start()

func matchActualLevel():
	if points >= 10:
		actualLevel = 2
	if points >= 25:
		actualLevel = 3
	if points >= 50:
		actualLevel = 4
	if points >= 75:
		actualLevel = 5
	if points >= 100:
		actualLevel = 6
	if points >= 125:
		actualLevel = 7
		
		#speed up
		genTime_1 = genTime_1 - 0.2
		bombGenTime = bombGenTime - 1
		bladeGenTime = bladeGenTime - 2
	if points >= 140:
		actualLevel = 8
	if points >= 160:
		actualLevel = 9
		
		#speed up
		genTime_1 = genTime_1 - 0.2
		bombGenTime = bombGenTime - 1
		bladeGenTime = bladeGenTime - 2
	if points >= 180:
		actualLevel = 10
		
		#speed up
		genTime_1 = genTime_1 - 0.2
		bombGenTime = bombGenTime - 1
		bladeGenTime = bladeGenTime - 2
	
func enemyGenerator():
	timerRegulars.start()
	timerBombs.start()
	timerBlades.start()

#region -> regulars
func genRegular():
	var gen = int(rand_range(0,2))
	if gen == 1:
		if actualLevel == 1:
			var ins = hammer.instance()
			var sel = int(rand_range(0, firstPositions.size()))
			ins.global_position = firstPositions[sel].global_position
			startRegular(ins, sel)
		elif actualLevel == 2:
			var regulars = [
				hammer.instance(),
				key.instance()
			]
			var ins = regulars[int(rand_range(0, regulars.size()))]
			var sel = int(rand_range(0, firstPositions.size()))
			ins.global_position = firstPositions[sel].global_position
			startRegular(ins, sel)
		elif actualLevel == 3:
			var regulars = [
				hammer.instance(),
				key.instance()
			]
			var ins = regulars[int(rand_range(0, regulars.size()))]
			var sel = int(rand_range(0, topPositions.size()))
			ins.global_position = topPositions[sel].global_position
			startRegular(ins, sel)
		elif actualLevel >= 4:
			var regulars = [
				hammer.instance(),
				key.instance()
			]
			var ins = regulars[int(rand_range(0, regulars.size()))]
			var sel = int(rand_range(0, allPositions.size()))
			ins.global_position = allPositions[sel].global_position
			startRegular(ins, sel)

func startRegular(ins, sel):
	enemyGroup.add_child(ins)
	if actualLevel <= 2:
			if sel < 4:
				ins.setDirectionAndStart(2)
			elif sel < 9:
				ins.setDirectionAndStart(3)
	elif actualLevel == 3:
		ins.setDirectionAndStart(1)
	else:
		if sel < 4:
			ins.setDirectionAndStart(2)
		elif sel < 9:
			ins.setDirectionAndStart(3)
		else:
			ins.setDirectionAndStart(1)

func _on_Timer_Regulars_timeout():
	genRegular()
	timerRegulars.wait_time = genTime_1
	timerRegulars.start()
#end region -> regulars

#region -> bombs
func genBomb():
	var ins = bomb.instance()
	enemyGroup.add_child(ins)
	var sel = int(rand_range(0, topPositions.size()))
	ins.global_position = topPositions[sel].global_position

func _on_Timer_Bombs_timeout():
	if actualLevel >= 5:
		genBomb()
	timerBombs.wait_time = bombGenTime
	timerBombs.start()
#end region -> bombs

#region -> coins
func genCoin():
	var randX = rand_range(20, viewPortRange.x - 20)
	var randY = rand_range(20, viewPortRange.y - 20)
	var ins = coin.instance()
	ins.global_position = Vector2(randX, randY)
	coinGroup.add_child(ins)

func _on_Timer_GenCoin_timeout():
	points += 1
	genCoin()
	timerGenCoin.start()
#end region -> coins

#region -> blades
func genBlades():
	#var ins = blades.instance()
	#enemyGroup.add_child(ins)
	#var sel = int(rand_range(0, bladesPositions.size()))
	#ins.global_position = bladesPositions[sel].global_position
	#if sel == 0:
	#	ins.setDirectionAndStart(2)
	#else:
	#	ins.setDirectionAndStart(3)
	pass

func _on_Timer_Blades_timeout():
	if actualLevel >= 6:
		genBlades()
	timerBlades.wait_time = bladeGenTime
	timerBlades.start()
#endregion -> blades

#region -> interactions
func _on_Player_CoinCollected(points):
	player1Points.text = str(points)

func _on_Player_Lose(points):
	get_tree().paused = true
	pointsOnDialog.text = str(points)
	loseDialog.show()
	
func _on_KillZone_area_entered(area):
	area.queue_free()

func _on_KillZone_body_entered(body):
	body.queue_free()

#end region -> interactions

#region -> lose dialog
func _on_Restart_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/GamePlay.tscn")

func _on_BackToMenu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://gui/Main.tscn")

func _on_Exit_pressed():
	get_tree().quit()
#endregion -> lose diaglog

#region -> pause
func _on_Pause_pressed():
	get_tree().paused = true
	pauseDialog.show()
	
func _on_Options_pressed():
	pass # Replace with function body.

func _on_Continue_pressed():
	continueGame()

func continueGame():
	timerToContinue.start()
	continueLabel.show()
	pauseDialog.hide()

func _on_TimerToContinue_timeout():
	get_tree().paused = false
	continueLabel.hide()
#endregion -> pause

#region -> power coins
func genPowerCoin():
	var randX = rand_range(20, viewPortRange.x - 20)
	var randY = rand_range(20, viewPortRange.y - 20)
	var sel = int(rand_range(0, powerCoins.size()))
	var ins = powerCoins[sel].instance()
	ins.global_position = Vector2(randX, randY)
	coinGroup.add_child(ins)

func _on_Timer_GenPowerCoin_timeout():
	genPowerCoin()
	timerGenPowerCoins.start()
#end region -> power coins

#region -> power btn
func _on_TimerPowerSpeed_timeout():
	powerSpeedBtn.disabled = false
	powerSpeedLabel.show()

func _on_TimerPowerShield_timeout():
	powerShieldBtn.disabled = false
	powerShieldLabel.show()

func _on_SpeedPower_pressed():
	usingSpeedPower()

func _on_ShieldPower_pressed():
	usingShieldPower()

func usingSpeedPower():
	powerSpeedBtn.disabled = true
	powerSpeedLabel.hide()
	timerPowerSpeed.start()
	player1.getSpeedPower()

func usingShieldPower():
	powerShieldBtn.disabled = true
	powerShieldLabel.hide()
	timerPowerShield.start()
	player1.getShieldPower()
#end region -> power btn

