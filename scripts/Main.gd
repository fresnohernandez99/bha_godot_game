extends Control

var playerNum = 0

#nodes
onready var missionDialog = $MisionSelect

 
func _on_1Player_button_up():
	showGameTypes(1)


func _on_2Player_button_up():
	showGameTypes(2)


func showGameTypes(pN):
	missionDialog.show()
	self.playerNum = pN


func _on_CloseDialog_pressed():
	playerNum = 0
	missionDialog.hide()


func _on_Mission_pressed():
	get_tree().change_scene("res://scenes/GamePlay.tscn")

func _on_Options_pressed():
	get_tree().change_scene("res://gui/Options.tscn")

func _on_Exit_pressed():
	get_tree().quit()
