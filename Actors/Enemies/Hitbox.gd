extends Area2D

onready var body_collision = $"../CollisionShape2D"

export (float) var Attack = 10.0
export (float) var Health = 50.0

func _ready() -> void:
# warning-ignore:return_value_discarded
	$".".connect("body_entered", self, "damage")

func damage(body: Node) -> void:
	body.hit(Attack)
