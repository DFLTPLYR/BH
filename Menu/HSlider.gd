extends HSlider

onready var texture_progress: TextureProgress = $TextureProgress

func _ready() -> void:
	self.connect("mouse_entered", self, "has_focus")
	self.connect("mouse_exited", self, "release_focus")
	texture_progress.min_value = min_value
	texture_progress.max_value = max_value
	connect("value_changed", self, "give_data")

func give_data(val: float):
	texture_progress.value = val
