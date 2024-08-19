extends Node2D

var inventory = null

func _ready() -> void:
	inventory = get_parent().inventory

func update_GunSlot(item):
	if item is Item:
		if self.get_child_count() == 0:
			if item.scene_path:
				var gunScene = (load(item.scene_path) as PackedScene).instance()
				gunScene.item = item.stats
				self.add_child(gunScene)

func fetus_deletus(item):
	if item == null:
		for fetus in self.get_children():
			self.remove_child(fetus)
			fetus.queue_free()
	else:
		pass
