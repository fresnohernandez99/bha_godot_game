extends Timer

var label

func _process(delta):
	renderContinueLabel()

func renderContinueLabel():
	if time_left >= 3:
		label.text = "3..."
	elif time_left >= 2:
		label.text = "2..."
	elif time_left >= 1:
		label.text = "1..."
	elif time_left >= 0:
		label.text = "GO!"
