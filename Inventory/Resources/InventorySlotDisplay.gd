extends CenterContainer

var inventory = null
#var Item = load("res://Inventory/Resources/GunRes.gd")

export (NodePath) onready var itemTextRect = get_node(itemTextRect) as TextureRect

var item_shader = preload("res://Inventory/Resources/InventorySlotDisplay.tres").duplicate(false)

onready var textrect = $itemTextureRect

func _ready() -> void:
	inventory = get_parent().inventory
	connect("mouse_entered", self, "display_Stats")

func update_display(item):
	if inventory:
		if item is Item:
			itemTextRect.texture = item.texture
			set_shader(itemTextRect, item)
		else:
			itemTextRect.material = null
			itemTextRect.texture = load("res://Assests/Inventory/ItemSocket.png")

func set_shader(text_rect,item):
	text_rect.material = item_shader
	if item.stats.rarity == "legendary":
		text_rect.material.set("shader_param/color", Color(0.85,0.48,0.5,1))
	if item.stats.rarity == "epic":
		text_rect.material.set("shader_param/color", Color(0.92,0.5,0.97,1))
	if item.stats.rarity == "uncommon":
		text_rect.material.set("shader_param/color", Color(0.15,0.20,0.98,1))
	if item.stats.rarity == "common":
		text_rect.material.set("shader_param/color", Color(0.79,0.80,0.94,1))
	if item.stats.rarity == "shi - tier":
		text_rect.material.set("shader_param/color", Color(1,1,1,1))

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			var item_index = get_index()
			var item = inventory.items[item_index]
			if item != null:
				inventory.remove_item(item_index)
				update_display(item_index)

func display_Stats():
	var item_index = get_index()
	var item = inventory.items[item_index]
	if item != null:
		var tooltip = preload("res://custom_tooltip/Tooltip.tscn").instance()
		tooltip.get_node("Tooltip").item_res = item
		add_child(tooltip)
