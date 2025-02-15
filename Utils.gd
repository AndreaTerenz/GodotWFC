extends Node

func compare_images(imgA: Image, imgB: Image):
	var size := imgA.get_size()
	
	if size != imgB.get_size():
		return false
	
	for r in range(size.y):
		for c in range(size.x):
			var self_pixel := imgA.get_pixel(c, r)
			var other_pixel := imgB.get_pixel(c, r)
			
			if (self_pixel != other_pixel):
				return false
	
	return true
