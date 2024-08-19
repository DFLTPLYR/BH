extends Area2D

var target = null

func can_see_enemy():
	return target != null

func _on_InnerDetectionArea_body_entered(body: Node) -> void:
	target = body

func _on_InnerDetectionArea_body_exited(body: Node) -> void:
	target = null
