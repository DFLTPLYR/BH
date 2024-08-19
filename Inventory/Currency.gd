extends HBoxContainer

onready var compare: Label = $compare

func _process(delta: float) -> void:
	if ShopItems.item_cost:
		compare.text = "%s / %s" % [round(ShopItems.currency), ShopItems.item_cost]
