class_name Cell
extends RefCounted

var options : Array = []
var collapsed := false
var stepped := false
var entropy := 0.0
var entropy_stale := true

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
	entropy = 0.
	entropy_stale = true
	
func reset_step():
	if collapsed:
		return
		
	stepped = false
	
func get_entropy(tiles_data: Array[Tile]) -> float:
	if not entropy_stale:
		return entropy 
	
	if collapsed:
		return 0.
		
	entropy_stale = false
	entropy = 0.0
		
	var sum : int = options.reduce(func(acc: int, idx: int): return acc + tiles_data[idx].frequency, 0)
	
	for option in options:
		var freq := tiles_data[option].frequency
		var prob := float(freq) / float(sum)
		var delta := prob * (log(prob) / log(2.))
		
		entropy -= delta
	
	return entropy

func update_options(target_tiles_idxs: Array[int]):
	options = options.filter(func(tile_idx):
		return tile_idx in target_tiles_idxs
	)
	entropy_stale = true
