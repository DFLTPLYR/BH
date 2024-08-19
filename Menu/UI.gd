extends CanvasLayer

onready var shop_ui: CanvasLayer = $ShopUi
onready var inventory_ui: CanvasLayer = $InventoryUI



func _ready() -> void:
	$".".visible = false
	shop_ui.visible = false
	inventory_ui.visible = false
	Signals.player_Selected.connect("focus", self, "show")

# warning-ignore:unused_argument

func show():
	$".".visible = !$".".visible
	shop_ui.visible = !shop_ui.visible
	inventory_ui.visible = !inventory_ui.visible

