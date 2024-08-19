extends Area2D

onready var weapon_starter: Area2D = $"."
onready var item_name: Label = $Sprite/itemName

var weapon = null

func _ready() -> void:
	weapon_starter.connect("area_entered", self, "weapon_Aquired")
	create_item()

func create_item():
	item_name.text = "%s" % ShopItems.Shop_item[0]["name"]
	var item = ShopItems.Shop_item[0]["reference"]
	item = load(item).duplicate(false) as Resource
	weapon = item

func weapon_Aquired(body: Area2D):
	if body.get_parent().is_in_group("Player"):
		print(body)
		var inventory = body.get_parent().Inventory_Resource
		inventory.set_item(0, weapon)
		weapon = null
		if !weapon:
			self.queue_free()
