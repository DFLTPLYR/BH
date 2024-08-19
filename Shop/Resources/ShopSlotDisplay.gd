extends CenterContainer

export var purchase_succesful = preload("res://Sounds/UI/Retro Instrument - choir bass - C00.wav")
export var purchase_unsuccesful = preload("res://Sounds/UI/Retro Instrument - choir bass - C04.wav")

var shop = preload("res://Shop/Resources/Shop.tres")
var Item = load("res://Inventory/Resources/GunRes.gd")
var inventory = null
var item_id = null
var tooltip_node = null

export (NodePath) onready var itemTextRect = get_node(itemTextRect) as TextureRect
onready var black_smith: KinematicBody2D = $"../../../../.."
onready var ui: CanvasLayer = $"../../../.."

var item_shader = preload("res://Inventory/Resources/InventorySlotDisplay.tres").duplicate(false)

func _ready() -> void:
	randomize()
	black_smith.connect("player_inventory_connect", self, "get_data")
	connect("mouse_entered", self, "display_Stats")


func _process(delta: float) -> void:
	var item = get_index()
	var slot = shop.items[item]
	update_shop(slot)

func get_data(data):
	inventory = data.Inventory_Resource

func display_Stats():
	var index = get_index()
	var shopSlot = shop.items[index]
	if shopSlot:
		item_id = shopSlot
		if item_id:
			ShopItems.item_cost = item_id.stats.Cost
			var tooltip = preload("res://custom_tooltip/Tooltip.tscn").instance()
			tooltip.get_node("Tooltip").item_res = item_id
			tooltip_node = tooltip
			add_child(tooltip)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var inv_slot = inventory.items.find(null)
			var item_index = get_index()
			if inv_slot != -1 and item_id:
				ShopItems.check_price(item_id.stats.Cost)
				if ShopItems.attainable:
					Signals.play(purchase_succesful, self.get_global_transform_with_canvas())
					ShopItems.update_currency(-item_id.stats.Cost)
					inventory.set_item(inv_slot, item_id)
					shop.remove_item_slot(item_index)
					item_id = null
					ShopItems.item_cost = null
					tooltip_node.queue_free()
				else:
					Signals.play(purchase_unsuccesful, self.get_global_transform_with_canvas())

func update_shop(item):
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

# warning-ignore:unused_argument
func reroll_item(item, probability):
	var dic_items = ShopItems.Shop_item
	var slot = get_index()
	var value = shop.items[slot]
	var rand = dic_items[randi() % dic_items.size()]
	if probability <= 50:
		value = load(rand["reference"]).duplicate(false) as Resource
		shop.set_item(slot, value)
	elif probability >= 51:
		shop.set_item(slot, null)
