extends ItemList

func _ready():
	resized.connect(_update_columns)
	_update_columns()

#func _process(_delta):
	#size = get_parent().size

func _update_columns():
	print('size: ', size.x)
	var item_width := 120
	var columns = max(1, int(size.x / item_width))
	max_columns = columns
