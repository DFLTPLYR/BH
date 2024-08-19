extends Area2D

var target = null

func _ready() -> void:
	$".".connect("area_entered", self, "target_found")
	$".".connect("area_exited", self, "target_l")

func target_found(area: Area2D):
	target = area

func target_lost(area: Area2D):
	target = null
