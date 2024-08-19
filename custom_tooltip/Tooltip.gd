extends PanelContainer

var item_res = null

func _ready() -> void:
	add_to_group("Tooltip")
	get_parent().get_parent().connect("tree_exited", self, "queue_free")
	get_parent().get_parent().connect("mouse_exited", self, "queue_free")
	get_parent().get_parent().connect("hide", self, "queue_free")
	give_data()

func _process(delta: float) -> void:
	rect_global_position = get_global_mouse_position() + Vector2(10,10)

func give_data():
	$".".rect_scale = Vector2(.5,.5)
	$attribute_divider/attribute.attribute_value.text = "%s" % item_res.stats.damage
	$attribute_divider/attribute2.attribute_value.text = "%s" % item_res.stats.firerate
	$attribute_divider/attribute3.attribute_value.text = "%s" % item_res.stats.reloadSpeed
	$attribute_divider/attribute4.attribute_value.text = "%s" % item_res.stats.BulletSpread
	$attribute_divider/attribute5.attribute_value.text = "%s" % item_res.stats.magazine
	$attribute_divider/attribute6.attribute_value.text = "%s" % item_res.stats.rarity
	$attribute_divider/attribute7.attribute_value.text = "%s" % item_res.stats.Cost
 
