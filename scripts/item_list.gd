extends ItemList

func _ready():
	resized.connect(_update_columns)
	_update_columns()

func _update_columns():
	var item_width := 120
	var columns = max(1, int(size.x / item_width))
	max_columns = columns
