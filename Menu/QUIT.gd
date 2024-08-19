extends Button

func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("button_up", Signals, "quit")
