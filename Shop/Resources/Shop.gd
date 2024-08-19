extends Resource
class_name Shop

signal items_changed(indexes)

export (Array, Resource) var items = [null, null, null, null, null, null, null, null, null]

func set_item(item_index, item):
	var prev_Item = items[item_index]
	items[item_index] = item
	emit_signal("items_changed", [item_index])
	return prev_Item
	
func remove_item_slot(item_index):
	var prev_Item = items[item_index]
	items[item_index] = null
	emit_signal("items_changed", [item_index])
	return prev_Item
