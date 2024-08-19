extends ColorRect

var shop = preload("res://Shop/Resources/Shop.tres")

onready var animate = $AnimationPlayer

func can_drop_data(position: Vector2, data) -> bool:
	return data is Dictionary and data.has("item")

func drop_data(position: Vector2, data) -> void:
	shop.set_item(data.item_index, data.item)
