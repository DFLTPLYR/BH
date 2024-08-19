extends Area2D
class_name Hitbox

onready var blood_particles: Particles2D = $Blood_particles

signal dead
signal damage_dealt(value)

export (NodePath) onready var parent = get_node(parent) as Node

func take_damage(value):
	if parent.velocity.x < 0:
		blood_particles.scale.x = 1
	elif parent.velocity.x > 0:
		blood_particles.scale.x = -1
	blood_particles.amount = value
	blood_particles.emitting = true
	emit_signal("damage_dealt", value)
	Signals.damage_text(self, value)
