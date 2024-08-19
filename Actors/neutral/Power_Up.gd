extends Area2D
class_name PowerUp

export (NodePath) onready var power_item = get_node(power_item) as Area2D
export (NodePath) onready var item_rect = get_node(item_rect) as TextureRect
export (NodePath) onready var item_name = get_node(item_name) as Label
export (NodePath) onready var animations = get_node(animations) as AnimationPlayer

func _ready() -> void:
	randomize()
	var chance = randi() % ShopItems.item_dictionary.size()
	
	item_rect.texture = ShopItems.item_dictionary[chance]["texture"]
	item_name.text = ShopItems.item_dictionary[chance]["name"]
	self.name = ShopItems.item_dictionary[chance]["name"]

	add_to_group("Power_ups")
	power_item.connect("area_entered", self, "_Aquired")
	animations.connect("animation_finished", self, "anim")
	if item_rect.texture != null:
		animations.play("spawned")

func anim(played: String):
	if played == "dissolve":
		queue_free()

func dict_search(XD):
	for item in ShopItems.item_dictionary:
		if item["name"] == XD:
			return item

func _Aquired(body: Area2D):
	if body.get_parent().is_in_group("Player"):
		var get_dic_index = dict_search(self.name)
		if self.name == "Health Up":
			var sound = load("res://Assests/SoundEffects/FreeSFX/GameSFX/PowerUp/Retro PowerUP 09.wav")
			body.get_parent().max_health += get_dic_index.value
			Signals.play(sound, self.global_transform)
			animations.play("dissolve")
		elif self.name == "Regen Boost":
			var sound = load("res://Assests/SoundEffects/FreeSFX/GameSFX/PowerUp/Retro PowerUP 09.wav")
			Signals.play(sound, self.global_transform)
			body.get_parent().regen(get_dic_index.value)
			animations.play("dissolve")
		elif self.name == "Speed Boost":
			var sound = load("res://Assests/SoundEffects/FreeSFX/GameSFX/PowerUp/Retro PowerUP 09.wav")
			Signals.play(sound, self.global_transform)
			body.get_parent().speed = body.get_parent().speed + get_dic_index.value
			animations.play("dissolve")
