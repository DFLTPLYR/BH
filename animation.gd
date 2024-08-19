tool
extends Node

onready var emotes_texture: Sprite = $emotes_texture
onready var animate_texture: AnimationPlayer = $animate_texture

export var confuse_loop = 0

func _ready() -> void:
	animate_texture.connect("animation_finished", self, "_animate_end")
	animate_texture.play("confuse")

func _animate_end(animated: String):
	if animated == "confuse":
		confuse_loop = confuse_loop + 1
		animate_texture.play("confuse")
		if confuse_loop == 7:
			animate_texture.stop()
