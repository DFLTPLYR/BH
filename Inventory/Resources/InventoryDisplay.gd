extends GridContainer

onready var inventory_window: NinePatchRect = $"../.."

onready var slots = preload("res://Inventory/Resources/InventorySlotDisplay.tscn")

var inventory = null

func _ready() -> void:
	inventory = Signals.player_Selected.Inventory_Resource
	if inventory:
		inventory.connect("items_changed", self, "_on_items_changed")
		inventory_slots()
		update_inventory_display()

func inventory_slots():
	for i in Signals.player_Selected.Inventory_Resource.items.size():
		add_child(slots.instance())

func update_inventory_display():
	for item_index in inventory.items.size():
		update_inventory_slot_display(item_index)

func update_inventory_slot_display(item_index):
	var inventorySlot = get_child(item_index)
	var item = inventory.items[item_index]
	inventorySlot.update_display(item)

func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)
