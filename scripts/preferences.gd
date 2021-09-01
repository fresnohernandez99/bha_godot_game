extends Node

#route
const PATH = "user://preferences.json"

var is_loaded = false

var data = {
	"username" : "Player",
	"difficulty" : 0,
	"music" : 0,
	"sfx" : 0
}
func _ready():
	var file = File.new()
	if file.file_exists(PATH):
		load_data()
	else:
		save_data()
		load_data()

func save_data():
	var file = File.new() 
	
	file.open(PATH, File.WRITE)
	file.store_string(to_json(data))
	file.close()
	
	is_loaded = false


func load_data():
	if is_loaded:
		return
	
	var file = File.new()
	
	file.open(PATH, File.READ)
	data = parse_json(file.get_line())
	file.close()
	
	is_loaded = true
