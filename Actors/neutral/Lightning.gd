extends Node2D
onready var sprite = $anim

# warning-ignore:unused_signal
signal done(lightning_position)

func _ready() -> void:
	sprite.connect("animation_finished", get_node("/root/Menu/Menu/PLAY"), "anim_End")
	emit_signal("done", global_position)
