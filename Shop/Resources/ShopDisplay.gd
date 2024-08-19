extends GridContainer

export var purchase_succesful = preload("res://Sounds/UI/Retro Instrument - choir bass - C00.wav")
export var purchase_unsuccesful = preload("res://Sounds/UI/Retro Instrument - choir bass - C04.wav")

var shop = preload("res://shop/Resources/Shop.tres")

onready var button = $"../../Button"

func _ready() -> void:
	shop.connect("items_changed", self, "_on_items_changed")
	button.connect("button_up", self, "update_display")
	button.connect("button_up", self, "reroll_cost")
	update_display()

func reroll_cost():
	if ShopItems.value >= ShopItems.reroll_cost:
		ShopItems.reroll_cost += 10
		ShopItems.value = ShopItems.value - ShopItems.reroll_cost
		Signals.play(purchase_succesful, self.get_global_transform_with_canvas())
	else:
		Signals.play(purchase_unsuccesful, self.get_global_transform_with_canvas())

func update_display():
	for item_index in shop.items.size():
		var probability = ShopItems.rng.randi_range(1, 100)
		update_shop_reroll(item_index, probability)

func update_shop_slot_display(item_index):
	var shopSlot = get_child(item_index)
	var item = shop.items[item_index]
	shopSlot.update_shop(item)

func update_shop_reroll(item_index, probability):
	var shopSlot = get_child(item_index)
	var item = shop.items[item_index]
	shopSlot.reroll_item(item, probability)

func _on_items_changed(indexes):
	for item_index in indexes:
		update_shop_slot_display(item_index)
