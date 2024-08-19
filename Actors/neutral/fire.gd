extends Node2D

onready var animate = $AnimationPlayer
onready var sprite = $Sprite

var count

func _ready() -> void:
	animate.connect("animation_finished", self, "anim_end")

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if count == 10:
		sprite.call_deferred("modulate", Color(255,255,255, 200))
	if count == 30:
		sprite.call_deferred("modulate", Color(255,255,255, 150))
	if count == 40:
		sprite.call_deferred("modulate", Color(255,255,255, 100))
	if count == 60:
		$".".queue_free()

func anim_end(anim: String):
	if anim == "fire":
		count += 1
