class_name Cell
extends RefCounted

var options : Array = []
var collapsed := false
var stepped := false

func _init(tiles_count: int):
	options = range(tiles_count)

func collapse(choice := -1):
	if len(options) <= 0:
		return -1
		
	if collapsed:
		return options[0]
	
	if choice < 0:
		choice = options.pick_random()
		
	options = [choice]
	collapsed = true
	
	return choice
	
func full_reset(tiles_count: int):
	options = range(tiles_count)
	collapsed = false
	stepped = false
	
func reset_step():
	if collapsed:
		return
		
	stepped = false
