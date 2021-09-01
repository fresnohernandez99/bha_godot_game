extends Control

#nodes
onready var music = $MusicVolume
onready var sfx = $SfxVolume
onready var difficulty = $Difficultybar

func _ready():
	music.value = Preferences.data.music
	sfx.value = Preferences.data.sfx
	difficulty.value = Preferences.data.difficulty


func _on_MusicVolume_value_changed(value):
	Preferences.data.music = value


func _on_Difficultybar_value_changed(value):
	Preferences.data.difficulty = value


func _on_SfxVolume_value_changed(value):
	Preferences.data.sfx = value

func _exit_tree():
	Preferences.save_data()


func _on_Back_pressed():
	get_tree().change_scene("res://gui/Main.tscn")
