extends Button

export (NodePath) onready var parent_root = get_node(parent_root) as KinematicBody2D

func _ready() -> void:
	self.connect("button_up", self, "next_wave")

func next_wave():
	Signals.change_camera(Signals.player_Selected, Signals.player_Selected.eye_sight, 1.5)
	Signals.resume()
	parent_root.queue_free()
