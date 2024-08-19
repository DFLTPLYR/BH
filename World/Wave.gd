extends TextureProgress

onready var wave_anim: AnimationPlayer = $wave_anim

func _ready() -> void:
	Signals.connect("wave_Start", self, "anim")

func anim():
	wave_anim.play("wave_info")
