extends Area2D
class_name Hurt_box

export (NodePath) onready var parent = get_node(parent) as Node
export (NodePath) onready var collision = get_node(collision) as CollisionShape2D

func _ready() -> void:
	collision.disabled = true
	connect("area_entered", self, "hit")

func hit(area: Area2D):
	if area.has_method("take_damage"):
		area.take_damage(parent.Damage)
