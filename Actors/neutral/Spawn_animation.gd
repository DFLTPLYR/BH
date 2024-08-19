extends Position2D

signal finished

var child = null
var location = null

func _ready() -> void:
	$AnimationPlayer.connect("animation_finished", self, "proceed")

func proceed(anim_name: String):
	if anim_name == "spawn":
		location.call_deferred("add_child", child)
		child.transform = transform
		call_deferred("queue_free")
