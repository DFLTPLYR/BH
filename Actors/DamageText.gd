extends Position2D

onready var label = $Label
var amount = 0

func _ready() -> void:
	label.set_text(str(amount))
