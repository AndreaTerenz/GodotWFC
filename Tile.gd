class_name Tile
extends RefCounted

enum TILE_SIDE {
	NORTH,
	SOUTH,
	EAST,
	WEST,
}

var index := -1
var top_left := Vector2i.ZERO
var frequency := 0
var image : Image
var texture : ImageTexture
var neighbors : Dictionary[TILE_SIDE, Array] = {}

var size : Vector2i :
	get:
		return image.get_size()

func _init(x: int, y: int, idx: int, image: Image):
	var tl := Vector2i(x, y)
	
	self.top_left = tl
	self.index = idx
	self.image = image #source_img.get_region(Rect2i(tl, sample_size))
	self.texture = ImageTexture.create_from_image(self.image)
	self.frequency = 1
	
	for key in TILE_SIDE.keys():
		self.neighbors[TILE_SIDE.get(key)] = []
		
func overlaps(other: Tile, side: TILE_SIDE):
	var tl_self := Vector2i.ZERO
	var tl_other := Vector2i.ZERO
	var slice_size := size
	
	match side:
		TILE_SIDE.NORTH:
			tl_other = Vector2i(0, 1)
			slice_size.y -= 1
		TILE_SIDE.SOUTH:
			tl_self = Vector2i(0, 1)
			slice_size.y -= 1
		TILE_SIDE.EAST:
			tl_other = Vector2i(1, 0)
			slice_size.x -= 1
		TILE_SIDE.WEST:
			tl_self = Vector2i(1, 0)
			slice_size.x -= 1
	
	var self_side := image.get_region(Rect2i(tl_self, slice_size))
	var other_side := other.image.get_region(Rect2i(tl_other, slice_size))
	
	return Utils.compare_images(self_side, other_side)

func compare(other: Tile):
	return Utils.compare_images(image, other.image)
	
func fill_neighbors(others: Array[Tile]):
	for side_id in TILE_SIDE.keys():
		var side : TILE_SIDE = TILE_SIDE.get(side_id)
		
		neighbors[side] = others.filter(func(other: Tile):
			return other.index != self.index and overlaps(other, side)
		).map(func(t: Tile): return t.index)

func draw(canvas_rid: RID, pos: Vector2i, size: Vector2i):
	texture.draw_rect(canvas_rid, Rect2i(pos, size), false)

static func opposite_side(side: TILE_SIDE):
	match side:
		TILE_SIDE.NORTH:
			return TILE_SIDE.SOUTH
		TILE_SIDE.SOUTH:
			return TILE_SIDE.NORTH
		TILE_SIDE.EAST:
			return TILE_SIDE.WEST
		TILE_SIDE.WEST:
			return TILE_SIDE.EAST
