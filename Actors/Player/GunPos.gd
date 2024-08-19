extends Node2D

var inventory = null
var output = []
var lamp_pos

func _ready() -> void:
# warning-ignore:unused_variable
	inventory = get_parent().Inventory_Resource
	lamp_pos = ShopItems.light_source
	if inventory:
		inventory.connect("items_changed", self, "_on_items_changed")
		add_gun_slot()

func add_gun_slot():
	var array_size = inventory.items.size()

	arrange_in_circle(array_size, 30.0, lamp_pos.position)

	for i in output.size():
		var position_mark = preload("res://Actors/neutral/pos1.tscn").instance()
		position_mark.name = str(position_mark.name, i+1)
		position_mark.position = output[i]
		$".".call_deferred("add_child", position_mark)
		if i == output.size():
			update_GunSlot_display()

func update_GunSlot_display():
	for item_index in inventory.items.size():
		update_slot_display(item_index)

func update_slot_display(item_index):
	var inventorySlot = get_child(item_index)
	var item = inventory.items[item_index]
	if item is Item:
		inventorySlot.update_GunSlot(item)
	if item == null:
		inventorySlot.fetus_deletus(item)

func _on_items_changed(indexes):
	for item_index in indexes:
		update_slot_display(item_index)

func arrange_in_circle(n: int, r: float, center=Vector2.ZERO, start_offset=0.0) -> Array:
	var offset = TAU / n
	for i in range(n):
		var pos = polar2cartesian(r, i * offset + start_offset)
		output.push_front(pos + center)
	return output
